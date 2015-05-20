angular.module('openCall.controllers').controller 'UsersController', 
['$scope', '$location', 'UsersService', ($scope, $location, UsersService) ->

  $scope.sessions = []
  
  $scope.sessions = () ->
    $scope.loading = true
    UsersService.user_sessions().then (sessions) ->
      $scope.sessions = sessions
      $scope.loading = false

  $scope.voted_sessions = () ->
    $scope.loading = true
    UsersService.user_voted_sessions().then (sessions) ->
      $scope.sessions = sessions
      $scope.loading = false

  $scope.remove_vote = (id) ->
    UsersService.toggle_vote_session(id, false).then () ->
      index = 0
      angular.forEach $scope.sessions, (session) ->
        $scope.sessions.splice index, 1  if id is session.id
        index += 1

  $scope.faved_sessions = () ->
    $scope.loading = true
    UsersService.user_faved_sessions().then (sessions) ->
      $scope.sessions = sessions
      $scope.loading = false

  $scope.remove_fav = (id) ->
    UsersService.toggle_fav_session(id).then () ->
      index = 0
      angular.forEach $scope.sessions, (session) ->
        $scope.sessions.splice index, 1  if id is session.id
        index += 1
]