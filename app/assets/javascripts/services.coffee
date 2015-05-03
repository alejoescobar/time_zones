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
        .then((response)-> response.data )
        .catch((response)-> throw response.data )


Auth.$inject = ["$http"]
services.factory("Auth",Auth)
