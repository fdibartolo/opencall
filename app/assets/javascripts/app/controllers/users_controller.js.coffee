angular.module('openCall.controllers').controller 'UsersController', 
['$scope', 'UsersService', ($scope, UsersService) ->

  $scope.sessions = []
  
  $scope.all = () ->
    UsersService.all().then (sessions) ->
      $scope.sessions = sessions
]