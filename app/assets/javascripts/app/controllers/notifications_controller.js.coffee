angular.module('openCall.controllers').controller 'NotificationsController', 
['$scope', 'constants', 'NotificationsService', ($scope, constants, NotificationsService) ->

  $scope.init = () ->

    $scope.$emit 'showLoadingSpinner', 'Loading...'
    NotificationsService.sessions().then ((sessions) ->
      $scope.sessions = sessions
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.goodReview = (score) ->
    score >= constants.reviews.score.goodThreshold

  $scope.poorReview = (score) ->
    score > constants.reviews.score.poorThreshold and score < constants.reviews.score.goodThreshold

  $scope.badReview = (score) ->
    score <= constants.reviews.score.poorThreshold

  $scope.isAcceptedReview = (status) ->
    status is constants.reviews.status.accepted

  $scope.isRejectedReview = (status) ->
    status is constants.reviews.status.rejected

  $scope.isPendingReview = (status) ->
    status is constants.reviews.status.pending

  $scope.isNewSession = (status) ->
    status is constants.sessions.status.new

  $scope.isAcceptedSession = (status) ->
    status is constants.sessions.status.accepted

  $scope.isDeclinedSession = (status) ->
    status is constants.sessions.status.declined
]