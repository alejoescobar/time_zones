controllers = angular.module("tzControllers",[])

SearchTimeZoneCtrl = ($scope,$routeParams,$location,$resource)->
  TimeZone = $resource('/time_zones/:recipeId', { recipeId: "@id", format: 'json' })

  $scope.search = (q)->
    $location.path("/").search('q',q)


  if $routeParams.q
    q = $routeParams.q.toLowerCase()
    TimeZone.query(q: $routeParams.q, (results)->
      $scope.time_zones = results
    )

  else
    $scope.time_zones = TimeZone.query()

SearchTimeZoneCtrl.$inject = ["$scope","$routeParams","$location","$resource"]
controllers.controller("SearchTimeZoneCtrl", SearchTimeZoneCtrl)
