app = angular.module('openCall', ['ngRoute', 'ngAnimate', 'toaster', 'sticky', 'highcharts-ng', 'openCall.controllers', 'openCall.services', 'openCall.directives', 'openCall.constants'])

controllers = angular.module('openCall.controllers', [])
services = angular.module('openCall.services', [])
directives = angular.module('openCall.directives', [])
constants = angular.module('openCall.constants', [])

app.config ['$httpProvider', '$routeProvider', ($httpProvider, $routeProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken  
  
  $routeProvider.when '/home',
    templateUrl: '/templates/home.html'

  $routeProvider.when '/sessions',
    templateUrl: '/templates/sessions/index.html'
    controller: 'SessionsController'

  $routeProvider.when '/sessions/new',
    templateUrl: '/templates/sessions/new.html'
    controller: 'SessionsController'

  $routeProvider.when '/sessions/show/:id',
    templateUrl: '/templates/sessions/show.html'
    controller: 'SessionsController'

  $routeProvider.when '/sessions/edit/:id',
    templateUrl: '/templates/sessions/new.html'
    controller: 'SessionsController'

  $routeProvider.when '/sessions/review/:id',
    templateUrl: '/templates/sessions/review.html'
    controller: 'SessionsController'

  $routeProvider.when '/error/:key',
    templateUrl: '/templates/error.html'
    controller: 'ErrorsController'

  $routeProvider.when '/users/sessions',
    templateUrl: '/templates/users/sessions.html'
    controller: 'UsersController'

  $routeProvider.when '/users/voted_sessions',
    templateUrl: '/templates/users/voted_sessions.html'
    controller: 'UsersController'

  $routeProvider.when '/users/faved_sessions',
    templateUrl: '/templates/users/faved_sessions.html'
    controller: 'UsersController'

  $routeProvider.when '/users/reviews',
    templateUrl: '/templates/users/reviews.html'
    controller: 'UsersController'

  $routeProvider.when '/stats',
    templateUrl: '/templates/stats.html'
    controller: 'StatsController'

  $routeProvider.when '/acceptance_notifications',
    templateUrl: '/templates/notifications/acceptance.html'
    controller: 'NotificationsController'

  $routeProvider.when '/author_inbox',
    templateUrl: '/templates/notifications/author_inbox.html'
    controller: 'NotificationsController'

  $routeProvider.when '/reports/reviewer_comments',
    templateUrl: '/templates/reports/reviewer_comments.html'
    controller: 'ReportsController'

  $routeProvider.when '/reports/reviews_status',
    templateUrl: '/templates/reports/reviews_status.html'
    controller: 'ReportsController'

  $routeProvider.otherwise redirectTo: '/home'
]

app.factory "httpInterceptor", ['$q', '$window', ($q, $window) ->
  return (
    responseError: (response) ->
      $window.location.href = "#{BASE_URL}users/sign_in"  if response.status is 401
      $q.reject response
  )
]

app.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push "httpInterceptor"
]