angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', '$location', 'SessionsService', ($scope, $location, SessionsService) ->

  $scope.sessions = []
  $scope.newSession = 
    title: ''
    description: ''

  $scope.init = () ->
    SessionsService.all().then (sessions) ->
      $scope.sessions = sessions

  $scope.createSession = () ->
    SessionsService.create($scope.newSession).then () ->
      $location.path '/sessions'
]