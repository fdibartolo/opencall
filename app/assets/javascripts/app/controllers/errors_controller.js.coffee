angular.module('openCall.controllers').controller 'ErrorsController', ['$scope', '$routeParams', ($scope, $routeParams) ->
  
  $scope.error = ''

  $scope.init = () ->
    switch $routeParams.key
      when 'session_not_found' then $scope.error = 'La sesión que buscas no existe'
      when 'generic' then $scope.error = 'Hubo un problema con la petición, por favor intenta mas tarde'
]
