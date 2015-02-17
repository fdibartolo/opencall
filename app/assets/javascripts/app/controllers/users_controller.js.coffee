angular.module('openCall.controllers').controller 'UsersController', 
['$scope', '$location', 'UsersService', ($scope, $location, UsersService) ->

  $scope.sessions = []
  $scope.reviews = []
  
  $scope.sessions = () ->
    $scope.loading = true
    UsersService.user_sessions().then (sessions) ->
      $scope.sessions = sessions
      $scope.loading = false

  $scope.reviews = () ->
    $scope.loading = true
    UsersService.user_reviews().then ((reviews) ->
      $scope.reviews = reviews
      $scope.loading = false
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.goodReview = (score) ->
    score >= 7

  $scope.poorReview = (score) ->
    score > 3 and score < 7

  $scope.badReview = (score) ->
    score <= 3
]