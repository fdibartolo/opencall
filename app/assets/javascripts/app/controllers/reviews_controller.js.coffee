angular.module('openCall.controllers').controller 'ReviewsController', 
['$scope', '$location', '$routeParams', 'toaster', 'ReviewsService', 'SessionsService', 'UsersService', 
($scope, $location, $routeParams, toaster, ReviewsService, SessionsService, UsersService) ->

  $scope.reviews = []
  $scope.newSessionReview = 
    body: ''
    score: 0
    status: ''

  $scope.initReviewForm = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    UsersService.user_review_for($routeParams.id).then ((review) ->
      $scope.newSessionReview = review  if review
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.postReview = () ->
    $scope.newSessionReview.invalidBody = $scope.newSessionReview.body is ''
    $scope.newSessionReview.invalidScore = $scope.newSessionReview.score is 0

    unless $scope.newSessionReview.invalidBody or $scope.newSessionReview.invalidScore
      ReviewsService.create($routeParams.id, $scope.newSessionReview).then (() ->
        $scope.newSessionReview.body = ''
        $scope.newSessionReview.score = 0
        $location.path "/users/reviews"
        toaster.pop 'success', '', 'Review submitted successfully', 5000
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

  $scope.loadSessionReviews = () ->
    ReviewsService.all($routeParams.id).then ((reviews) ->
      $scope.session.reviews = reviews
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.loadUserReviews = () ->
    $scope.loading = true
    UsersService.user_reviews().then ((reviews) ->
      $scope.reviews = reviews
      $scope.loading = false
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.acceptReview = (review) ->
    $scope.$emit 'showLoadingSpinner', 'Accepting...'
    ReviewsService.accept($routeParams.id, review.id).then (() ->
      review.status = 'accepted'
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    
  $scope.rejectReview = (review) ->
    $scope.$emit 'showLoadingSpinner', 'Rejecting...'
    ReviewsService.reject($routeParams.id, review.id).then (() ->
      review.status = 'rejected'
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    
  $scope.goodReview = (score) ->
    score >= 7

  $scope.poorReview = (score) ->
    score > 3 and score < 7

  $scope.badReview = (score) ->
    score <= 3

  $scope.isAcceptedReview = (status) ->
    status is 'accepted'

  $scope.isRejectedReview = (status) ->
    status is 'rejected'

  $scope.isPendingReview = (status) ->
    status is 'pending'

  $scope.isPendingOrNewReview = (status) ->
    $scope.isPendingReview(status) or $scope.isEmpty(status) or angular.isUndefined(status)

  $scope.isEmpty = (value) ->
    (value is null) or (value is '')

  $scope.loadProfileSummary = () ->
    if angular.isUndefined($scope.session.profile)
      SessionsService.authorsProfile($routeParams.id).then (profile) ->
        $scope.session.profile = profile
]
