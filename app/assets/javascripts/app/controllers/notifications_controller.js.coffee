angular.module('openCall.controllers').controller 'NotificationsController', 
['$scope', '$location', 'constants', 'NotificationsService', ($scope, $location, constants, NotificationsService) ->

  $scope.init = () ->
    $scope.$emit 'showLoadingSpinner', 'Loading...'
    NotificationsService.sessions().then ((sessions) ->
      $scope.sessions = sessions
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.acceptSession = (session) ->
    $scope.$emit 'showLoadingSpinner', 'Accepting and notifying...'
    NotificationsService.accept(session.id).then (() ->
      session.status      = constants.sessions.status.accepted
      session.notified_on = moment().format()
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.declineSession = (session) ->
    $scope.$emit 'showLoadingSpinner', 'Declining and notifying...'
    NotificationsService.decline(session.id).then (() ->
      session.status      = constants.sessions.status.declined
      session.notified_on = moment().format()
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

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