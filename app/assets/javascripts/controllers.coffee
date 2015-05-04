controllers = angular.module("tzControllers",[])

# SearchTimeZone
SearchTimeZoneCtrl = ($scope,$routeParams,$location,TimeZone,Auth)->
  $scope.current_user = Auth.current_user
  $scope.search = (q)->
    $location.path("/time_zones").search('q',q)
  $scope.sign_out = ->
    Auth.sign_out()
      .then( -> $location.path("/sign_in") )

  if $routeParams.q
    q = $routeParams.q.toLowerCase()
    TimeZone.query(q: $routeParams.q, (results)->
      $scope.time_zones = results
    )

  else
    $scope.time_zones = TimeZone.query()

SearchTimeZoneCtrl.$inject = ["$scope","$routeParams","$location","TimeZone","Auth"]
controllers.controller("SearchTimeZoneCtrl", SearchTimeZoneCtrl)

# SignUp
SignUpCtrl = ($scope,$location,Auth)->

  $scope.sign_up = (user)->
    Auth.sign_up(user)
      .then (data)->
        $location.path("/sign_in")
      .catch (errors)->
        $scope.errors = errors

SignUpCtrl.$inject = ["$scope","$location","Auth"]
controllers.controller("SignUpCtrl", SignUpCtrl)

# SignIn
SignInCtrl = ($scope,$location,Auth)->
  $scope.sign_in = (user)->
    Auth.sign_in(user)
      .then (data)->
        $location.path("/time_zones")
      .catch (errors)->
        $scope.errors = errors

SignInCtrl.$inject = ["$scope","$location","Auth"]
controllers.controller("SignInCtrl", SignInCtrl)
