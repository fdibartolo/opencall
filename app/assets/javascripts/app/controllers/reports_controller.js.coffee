angular.module('openCall.controllers').controller 'ReportsController', 
['$scope', '$location', 'constants', 'ReportsService', 'NotificationsService', 
($scope, $location, constants, ReportsService, NotificationsService) ->

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
    $scope.sort = constants.reports.sort.sessions.top

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

  $scope.getSessionsWithVotes = () ->
    $scope.$emit 'showLoadingSpinner', 'Loading...'
    ReportsService.communityVotes().then ((response) ->
      $scope.sessions = response.sessions
      prepareThemesFilter response.themes
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

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

  $scope.isSortBySessions = () ->
    isSortBy constants.reports.sort.sessions

  $scope.isSortByThemes = () ->
    isSortBy constants.reports.sort.themes

  $scope.isSortByReviews = () ->
    isSortBy constants.reports.sort.reviews

  isSortBy = (type) ->
    $scope.sort is type.top or $scope.sort is type.bottom

  $scope.toggleSessionsSort = () ->
    if $scope.isSessionsTopSort()
      $scope.sort = constants.reports.sort.sessions.bottom
    else
      $scope.sort = constants.reports.sort.sessions.top

  $scope.isSessionsTopSort = () ->
    $scope.isSortBySessions() and ($scope.sort.type is constants.reports.sort.sessions.top.type)
    
  $scope.isSessionsBottomSort = () ->
    $scope.isSortBySessions() and ($scope.sort.type is constants.reports.sort.sessions.bottom.type)
    
  $scope.toggleThemesSort = () ->
    if $scope.isThemesTopSort()
      $scope.sort = constants.reports.sort.themes.bottom
    else
      $scope.sort = constants.reports.sort.themes.top

  $scope.isThemesTopSort = () ->
    $scope.isSortByThemes() and ($scope.sort.type is constants.reports.sort.themes.top.type)
    
  $scope.isThemesBottomSort = () ->
    $scope.isSortByThemes() and ($scope.sort.type is constants.reports.sort.themes.bottom.type)
    
  $scope.toggleReviewsSort = () ->
    if $scope.isReviewsTopSort()
      $scope.sort = constants.reports.sort.reviews.bottom
    else
      $scope.sort = constants.reports.sort.reviews.top

  $scope.isReviewsTopSort = () ->
    $scope.isSortByReviews() and ($scope.sort.type is constants.reports.sort.reviews.top.type)
    
  $scope.isReviewsBottomSort = () ->
    $scope.isSortByReviews() and ($scope.sort.type is constants.reports.sort.reviews.bottom.type)
    
]