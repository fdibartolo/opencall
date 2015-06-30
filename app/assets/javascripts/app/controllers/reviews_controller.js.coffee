angular.module('openCall.controllers').controller 'ReviewsController', 
['$scope', '$location', '$routeParams', 'toaster', 'constants', 'ReviewsService', 'SessionsService', 'UsersService', 
($scope, $location, $routeParams, toaster, constants, ReviewsService, SessionsService, UsersService) ->

  $scope.reviews = []
  $scope.newSessionReview = 
    body: ''
    private_body: ''
    score: {}
    status: ''
    secondReviewer: {}
  $scope.validReviewScores = constants.reviews.score.values

  $scope.initReviewForm = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    UsersService.user_review_for($routeParams.id).then ((review) ->
      if review
        $scope.newSessionReview = review
        $scope.newSessionReview.score = setScore(review)
        $scope.newSessionReview.secondReviewer = setSecondReviewer(review)
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  setSecondReviewer = (review) ->
    return reviewer for reviewer in review.reviewers when reviewer.id is review.second_reviewer_id

  setScore = (review) ->
    return score for score in $scope.validReviewScores when score.value is review.score

  $scope.postReview = () ->
    $scope.newSessionReview.invalidBody           = $scope.newSessionReview.body is '' or angular.isUndefined($scope.newSessionReview.body)
    $scope.newSessionReview.invalidPrivateBody    = $scope.newSessionReview.private_body is '' or angular.isUndefined($scope.newSessionReview.private_body)
    $scope.newSessionReview.invalidScore          = $scope.newSessionReview.score is {} or angular.isUndefined($scope.newSessionReview.score)
    $scope.newSessionReview.invalidSecondReviewer = $scope.newSessionReview.secondReviewer is {} or angular.isUndefined($scope.newSessionReview.secondReviewer)

    unless $scope.newSessionReview.invalidBody or $scope.newSessionReview.invalidScore or 
    $scope.newSessionReview.invalidPrivateBody or $scope.newSessionReview.invalidSecondReviewer
      ReviewsService.create($routeParams.id, $scope.newSessionReview).then (() ->
        clearReview()
        $location.path "/users/reviews"
        toaster.pop 'success', '', 'Review submitted successfully', 5000
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

  clearReview = () ->
    $scope.newSessionReview.body           = ''
    $scope.newSessionReview.private_body   = ''
    $scope.newSessionReview.score          = {}
    $scope.newSessionReview.secondReviewer = {}

  $scope.loadSessionReviews = () ->
    ReviewsService.all($routeParams.id).then ((reviews) ->
      $scope.session.reviews = reviews
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.loadUserReviews = () ->
    $scope.loading = true
    UsersService.user_reviews().then ((reviews) ->
      $scope.reviews = []
      angular.forEach reviews, (review) ->
        review.score = setScoreFor(review)
        $scope.reviews.push review
      $scope.loading = false
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.acceptReview = (review) ->
    $scope.$emit 'showLoadingSpinner', 'Accepting...'
    ReviewsService.accept($routeParams.id, review.id).then (() ->
      review.status = constants.reviews.status.accepted
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    
  $scope.rejectReview = (review) ->
    $scope.$emit 'showLoadingSpinner', 'Rejecting...'
    ReviewsService.reject($routeParams.id, review.id).then (() ->
      review.status = constants.reviews.status.rejected
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    
  $scope.goodReview = (score) ->
    score >= constants.reviews.score.goodThreshold

  $scope.poorReview = (score) ->
    score > constants.reviews.score.poorThreshold and score < constants.reviews.score.goodThreshold

  $scope.badReview = (score) ->
    score <= constants.reviews.score.poorThreshold

  $scope.isAcceptedReview = (status) ->
    status is constants.reviews.status.accepted

  $scope.isRejectedReview = (status) ->
    status is constants.reviews.status.rejected

  $scope.isPendingReview = (status) ->
    status is constants.reviews.status.pending

  $scope.isPendingOrNewReview = (status) ->
    $scope.isPendingReview(status) or $scope.isEmpty(status) or angular.isUndefined(status)

  $scope.isEmpty = (value) ->
    (value is null) or (value is '')

  $scope.loadProfileSummary = () ->
    if angular.isUndefined($scope.session.profile)
      SessionsService.authorsProfile($routeParams.id).then (profile) ->
        $scope.session.profile = profile
]
