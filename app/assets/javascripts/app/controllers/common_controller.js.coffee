angular.module('openCall.controllers').controller 'CommonController', 
['$rootScope', '$scope', ($rootScope, $scope) ->

  $rootScope.showSpinner = false
  $rootScope.spinnerMessage = ""

  $rootScope.$on 'showLoadingSpinner', (e, message) ->
    $rootScope.spinnerMessage = message
    $rootScope.showSpinner = true

  $rootScope.$on 'hideLoadingSpinner', () ->
    $rootScope.showSpinner = false
]