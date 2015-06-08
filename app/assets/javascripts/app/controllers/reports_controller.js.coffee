angular.module('openCall.controllers').controller 'ReportsController', 
['$scope', 'ReportsService', ($scope, ReportsService) ->

  $scope.getReviewerCommentsInfo = () ->
    $scope.$emit 'showLoadingSpinner', 'Loading...'
    ReportsService.reviewerComments().then ((response) ->
      $scope.sessions = response.sessions
      $scope.themes = []
      angular.forEach response.themes, (themeName) ->
        theme =
          name: themeName
          active: true
        $scope.themes.push theme
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    
  $scope.isVisibleTheme = (themeName) ->
    t = theme for theme in $scope.themes when theme.name is themeName
    t.active
]