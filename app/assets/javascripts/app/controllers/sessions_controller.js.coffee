angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', 'SessionsService', ($scope, SessionsService) ->

  $scope.sessions = []

  $scope.init = () ->
    SessionsService.all().then (sessions) ->
      $scope.sessions = sessions

]