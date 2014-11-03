angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', 'SessionsService', ($scope, SessionsService) ->

  $scope.sessions = []
  $scope.showAddNewSession = false
  $scope.newSession = 
    author: ''
    title: ''
    description: ''

  $scope.init = () ->
    SessionsService.all().then (sessions) ->
      $scope.sessions = sessions

  $scope.createSession = () ->
    SessionsService.create($scope.newSession).then () ->
      $scope.sessions.push $scope.newSession
      $scope.showAddNewSession = false

]