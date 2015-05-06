controllers = angular.module("tzControllers",[])

# SearchTimeZone
SearchTimeZoneCtrl = ($scope,$routeParams,$location,$route,TimeZone)->

  $scope.search = (q)->
    $location.path("/time_zones").search('q',q)
  $scope.delete_time_zone = (time_zone_id)->
    TimeZone.delete({id: time_zone_id})
      .$promise
      .then( -> $route.reload() )

  if $routeParams.q
    $scope.q = $routeParams.q.toLowerCase()
    TimeZone.query(q: $scope.q, (results)->
      $scope.time_zones = results
    )

  else
    $scope.time_zones = TimeZone.query()

SearchTimeZoneCtrl.$inject = ["$scope","$routeParams","$location","$route","TimeZone"]
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

# NavigationCtrl
NavigationCtrl = ($scope,$location,Auth)->
  $scope.current_user = Auth.current_user

  $scope.sign_out = ->
    Auth.sign_out()
      .then( -> $location.path("/sign_in") )

NavigationCtrl.$inject = ["$scope","$location","Auth"]
controllers.controller("NavigationCtrl", NavigationCtrl)

# NewTimeZoneCtrl
NewTimeZoneCtrl = ($scope,$location,TimeZone)->
  $scope.action = "create"
  $scope.time_zone = {}
  $scope.submit = (time_zone)->
    time_zone = new TimeZone(time_zone)
    time_zone.$save()
      .then( -> $location.path("/time_zones") )
      .catch( (response)-> $scope.errors = response.data )


NewTimeZoneCtrl.$inject = ["$scope","$location","TimeZone"]
controllers.controller("NewTimeZoneCtrl", NewTimeZoneCtrl)


# EditTimeZoneCtrl
EditTimeZoneCtrl = ($scope,$location,$routeParams,TimeZone)->
  $scope.action = "update"
  $scope.time_zone = {}
  TimeZone.get {id: $routeParams.id}, (time_zone)->
    $scope.time_zone = new TimeZone(time_zone)

  $scope.submit = (time_zone)->

    TimeZone.update({id:$scope.time_zone.id},time_zone)
      .$promise
      .then( -> $location.path("/time_zones") )
      .catch( (response)-> $scope.errors = response.data )


EditTimeZoneCtrl.$inject = ["$scope","$location","$routeParams","TimeZone"]
controllers.controller("EditTimeZoneCtrl", EditTimeZoneCtrl)






##
