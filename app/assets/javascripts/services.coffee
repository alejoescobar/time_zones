services = angular.module("tzServices",[])

# TimeZone
TimeZone = ($resource)->
  $resource('/time_zones/:recipeId', { recipeId: "@id", format: 'json' })

TimeZone.$inject = ["$resource"]
services.factory("TimeZone",TimeZone)

# Auth
Auth = ($http,$q,$cookies)->
  new class
    sign_up: (user)->
      $http.post("/user/sign_up", user)
        .then( (response)-> response.data )
        .catch( (response)-> throw response.data )

    sign_in: (user)->
      $http.post("/user/sign_in", user)
        .then( (response)=>
          @current_user = response.data
          @_save_current_user()
          @_set_auth_headers()
          @current_user
        )
        .catch( (response)-> throw response.data )
    get_current_user: ->
      deferred = $q.defer();

      if @load_current_user()
        $http.get("/user")
          .then((response)-> deferred.resolve(response.data) )
          .catch((response)-> deferred.reject(response.data))
      else
        deferred.reject()

      deferred.promise

    load_current_user: ->
      @current_user = JSON.parse($cookies.current_user || null)
      if @current_user
        @_set_auth_headers()
      @current_user

    _save_current_user: ->
      $cookies.current_user = JSON.stringify(@current_user)

    _set_auth_headers: ->
      $http.defaults.headers.common["X-AUTH-EMAIL"] = @current_user.email;
      $http.defaults.headers.common["X-AUTH-TOKEN"] = @current_user.auth_token;



Auth.$inject = ["$http","$q","$cookies"]
services.factory("Auth",Auth)
