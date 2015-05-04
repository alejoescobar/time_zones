services = angular.module("tzServices",[])

# TimeZone
TimeZone = ($resource)->
  $resource('/time_zones/:recipeId', { recipeId: "@id", format: 'json' })

TimeZone.$inject = ["$resource"]
services.factory("TimeZone",TimeZone)

# Auth
Auth = ($http)->
  new class
    sign_up: (user)->
      $http.post("/user/sign_up", user)
        .then( (response)-> response.data )
        .catch( (response)-> throw response.data )

    sign_in: (user)->
      $http.post("/user/sign_in", user)
        .then( (response)=>
          @current_user = response.data
          @_set_auth_headers()
          @current_user
        )
        .catch( (response)-> throw response.data )
        
    _set_auth_headers: ()->
      $http.defaults.headers.common["X-AUTH-EMAIL"] = @current_user.email;
      $http.defaults.headers.common["X-AUTH-TOKEN"] = @current_user.auth_token;


Auth.$inject = ["$http"]
services.factory("Auth",Auth)
