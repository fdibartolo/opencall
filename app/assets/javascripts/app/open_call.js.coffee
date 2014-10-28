app = angular.module('openCall', ['ngRoute'])

app.config ['$httpProvider', '$routeProvider', ($httpProvider, $routeProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken  
  
  $routeProvider.when '/home',
    templateUrl: '/templates/home.html'

  $routeProvider.otherwise redirectTo: '/home'
]
