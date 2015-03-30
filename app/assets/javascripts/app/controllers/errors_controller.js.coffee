angular.module('openCall.controllers').controller 'ErrorsController', 
['$scope', '$routeParams', ($scope, $routeParams) ->
  
  $scope.error = ''

  $scope.init = () ->
    switch $routeParams.key
      when 'session_not_found' then $scope.error = 'Session proposal you are looking for does not exist'
      when 'theme_not_found' then $scope.error = 'Theme you are looking for does not exist'
      when 'access_denied' then $scope.error = 'You dont have access to perform this operation'
      when 'generic' then $scope.error = 'Oops, there was a problem, please try again later'
]
