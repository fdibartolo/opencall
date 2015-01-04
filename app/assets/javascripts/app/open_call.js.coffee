app = angular.module('openCall', ['ngRoute', 'openCall.controllers', 'openCall.services'])

controllers = angular.module('openCall.controllers', [])
services = angular.module('openCall.services', [])

app.config ['$httpProvider', '$routeProvider', ($httpProvider, $routeProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken  
  
  $routeProvider.when '/home',
    templateUrl: '/templates/home.html'

  $routeProvider.when '/sessions',
    templateUrl: '/templates/sessions.html'
    controller: 'SessionsController'

  $routeProvider.otherwise redirectTo: '/home'
]

app.factory "httpInterceptor", ['$q', '$location', ($q, $location) ->
  return (
    responseError: (response) ->
      $location.path "/home"  if response.status is 401
      $q.reject response
  )
]

app.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push "httpInterceptor"
]