angular.module('openCall.controllers').controller 'ReportsController', 
['$scope', 'constants', 'ReportsService', 'NotificationsService', 
($scope, constants, ReportsService, NotificationsService) ->

  $scope.getReviewerCommentsInfo = () ->
    $scope.$emit 'showLoadingSpinner', 'Loading...'
    ReportsService.reviewerComments().then ((response) ->
      $scope.sessions = response.sessions
      prepareThemesFilter response.themes
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.getReviewsStatus = () ->
    $scope.$emit 'showLoadingSpinner', 'Loading...'
    NotificationsService.sessions().then ((response) ->
      $scope.sessions = response.sessions
      prepareThemesFilter response.themes
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  prepareThemesFilter = (themes) ->
    $scope.themes = []
    angular.forEach themes, (themeName) ->
      theme =
        name: themeName
        active: true
      $scope.themes.push theme

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    
  $scope.isVisibleTheme = (themeName) ->
    t = theme for theme in $scope.themes when theme.name is themeName
    t.active

  $scope.isAcceptedReview = (status) ->
    status is constants.reviews.status.accepted

  $scope.isRejectedReview = (status) ->
    status is constants.reviews.status.rejected

  $scope.isPendingReview = (status) ->
    status is constants.reviews.status.pending
]