controllers = angular.module("tzControllers",[])


time_zones = [
  {id: "1", name: "bog", city: "bog", gmt_diff: "-5"}
  {id: "2", name: "quito", city: "quito", gmt_diff: "-3"}
  {id: "3", name: "NY", city: "NY", gmt_diff: "1"}
  {id: "4", name: "US", city: "US", gmt_diff: "0"}
  {id: "5", name: "madrid", city: "madrid", gmt_diff: "-10"}
  {id: "6", name: "amsterdam", city: "amsterdam", gmt_diff: "-1"}
  {id: "7", name: "washington", city: "washington", gmt_diff: "5"}
  {id: "8", name: "barranquilla", city: "barranquilla", gmt_diff: "5"}
  {id: "9", name: "buenos aires", city: "buenos aires", gmt_diff: "-7"}
  {id: "10", name: "milan", city: "milan", gmt_diff: "3"}
  {id: "11", name: "lima", city: "lima", gmt_diff: "2"}
  {id: "12", name: "sao paulo", city: "sao paulo", gmt_diff: "-4"}
  {id: "13", name: "medellin", city: "medellin", gmt_diff: "-4"}
  {id: "14", name: "parís", city: "parís", gmt_diff: "2"}

]
SearchTimeZoneCtrl = ($scope,$routeParams,$location)->

  $scope.search = (name)->
    $location.path("/").search('name',name)

  if $routeParams.name
    keywords = $routeParams.name.toLowerCase()
    $scope.time_zones = time_zones.filter (time_zone)->
      time_zone.name.toLowerCase().indexOf(keywords) != -1
  else
    $scope.time_zones = time_zones

SearchTimeZoneCtrl.$inject = ["$scope","$routeParams","$location"]
controllers.controller("SearchTimeZoneCtrl", SearchTimeZoneCtrl)
