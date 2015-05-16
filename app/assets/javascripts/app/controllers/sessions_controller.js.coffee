angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', '$location', '$routeParams', 'toaster', 'SessionsService', 'CommentsService', 'ReviewsService', 'UsersService'
($scope, $location, $routeParams, toaster, SessionsService, CommentsService, ReviewsService, UsersService) ->

  $scope.sessions = []
  $scope.matched_tags = []
  $scope.total = 0
  $scope.newSession = 
    title: ''
    theme_id: ''
    track_id: ''
    audience_id: ''
    audience_count: ''
    summary: ''
    description: ''
    video_link: ''
    tags: []
  $scope.sessionVotedIds = []
  $scope.sessionFavedIds = []
  $scope.availableVotes = MAX_SESSION_PROPOSAL_VOTES
  $scope.searchTerms = ''
  $scope.searchPageNumber = 1
  $scope.newSessionComment = 
    body: ''
    date: null
  $scope.newSessionReview = 
    body: ''
    score: 0
    status: ''

  $scope.initForm = () ->
    if angular.isDefined($routeParams.id)
      SessionsService.get($routeParams.id).then ((session) ->
        $scope.newSession = session
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"
    else
      SessionsService.new()

  $scope.isNew = () ->
    angular.isUndefined($scope.newSession.id)

  $scope.createSession = () ->
    if validSession()
      $scope.$emit 'showLoadingSpinner', 'Submitting...'
      SessionsService.create($scope.newSession).then (id) ->
        $location.path "/sessions/show/#{id}"
        $scope.$emit 'hideLoadingSpinner'
        toaster.pop 'success', '', 'Session proposal submitted successfully', 5000

  $scope.updateSession = () ->
    if validSession()
      SessionsService.update($scope.newSession).then (() ->
        $location.path "/sessions/show/#{$scope.newSession.id}"
        toaster.pop 'success', '', 'Session proposal updated  successfully', 5000
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

  validSession = () ->
    $scope.newSession.invalidTitle       = $scope.newSession.title is ''
    $scope.newSession.invalidSummary     = $scope.newSession.summary is ''
    $scope.newSession.invalidDescription = $scope.newSession.description is ''
    $scope.newSession.invalidTrackId     = $scope.newSession.track_id is ''
    $scope.newSession.invalidThemeId     = $scope.newSession.theme_id is ''
    $scope.newSession.invalidAudienceId  = $scope.newSession.audience_id is ''
    $scope.newSession.invalidVideo       = not validUrl($scope.newSession.video_link)

    not ($scope.newSession.invalidTitle or $scope.newSession.invalidSummary or 
      $scope.newSession.invalidDescription or $scope.newSession.invalidTrackId or
      $scope.newSession.invalidAudienceId or $scope.newSession.invalidThemeId or
      $scope.newSession.invalidVideo)

  validUrl = (url) ->
    url.match(/^(http(|s):\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-\?\&]*)\/?$/) isnt null

  $scope.getSessionVotedAndFavedIds = () ->
    if CURRENT_USER_EMAIL isnt ''
      UsersService.user_session_voted_ids().then (ids) ->
        $scope.sessionVotedIds = ids
        $scope.availableVotes -= $scope.sessionVotedIds.length
      UsersService.user_session_faved_ids().then (ids) ->
        $scope.sessionFavedIds = ids

  $scope.search = (termToAdd) ->
    $scope.loading = true
    $scope.searchTerms = "#{$scope.searchTerms} #{termToAdd}"  if angular.isDefined(termToAdd)
    $scope.searchPageNumber = 1 # reset page number
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      $scope.sessions     = addVotedAndFavedStatusFor(response.sessions)
      $scope.matched_tags = response.matched_tags  unless $scope.searchTerms is ''
      $scope.total        = response.total
      $scope.loading      = false

  addVotedAndFavedStatusFor = (sessions) ->
    angular.forEach sessions, (session) ->
      session.voted = $scope.sessionVotedIds.indexOf(session.id) isnt -1
      session.faved = $scope.sessionFavedIds.indexOf(session.id) isnt -1
    sessions

  $scope.loadMore = () ->
    $scope.searchPageNumber += 1
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      angular.forEach response.sessions, (session) ->
        session.voted = $scope.sessionVotedIds.indexOf(session.id) isnt -1
        session.faved = $scope.sessionFavedIds.indexOf(session.id) isnt -1
        $scope.sessions.push session

  $scope.vote = (index) ->
    $scope.sessions[index].voted = false  if angular.isUndefined($scope.sessions[index].voted)
    $scope.sessions[index].voted = !$scope.sessions[index].voted

    UsersService.toggle_vote_session($scope.sessions[index].id, $scope.sessions[index].voted).then () ->
      delta = if $scope.sessions[index].voted then -1 else 1
      $scope.availableVotes += delta  if $scope.availableVotes isnt 0 or delta is 1

  $scope.fav = (index) ->
    $scope.sessions[index].faved = false  if angular.isUndefined($scope.sessions[index].faved)
    $scope.sessions[index].faved = !$scope.sessions[index].faved

    UsersService.toggle_fav_session($scope.sessions[index].id)

  $scope.removeTag = (index) ->
    $scope.newSession.tags[index]._destroy = true

  $scope.show = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
      CommentsService.all($routeParams.id).then (comments) ->
        $scope.session.comments = comments
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.loadReviews = () ->
    ReviewsService.all($routeParams.id).then ((reviews) ->
      $scope.session.reviews = reviews
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.review = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
    UsersService.user_review_for($routeParams.id).then ((review) ->
      $scope.newSessionReview = review  if review
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.postComment = () ->
    if $scope.newSessionComment.body isnt ''
      $scope.$emit 'showLoadingSpinner', 'Commenting...'
      CommentsService.create($routeParams.id, $scope.newSessionComment).then () ->
        comment = 
          body: $scope.newSessionComment.body
          author:
            avatar_url: CURRENT_USER_AVATAR
          date: moment()
        $scope.session.comments.push comment
        $scope.newSessionComment.body = ''
        $scope.newSessionComment.date = null
        $scope.$emit 'hideLoadingSpinner'

  $scope.postReview = () ->
    $scope.newSessionReview.invalidBody = $scope.newSessionReview.body is ''
    $scope.newSessionReview.invalidScore = $scope.newSessionReview.score is 0

    unless $scope.newSessionReview.invalidBody or $scope.newSessionReview.invalidScore
      ReviewsService.create($routeParams.id, $scope.newSessionReview).then (() ->
        $scope.newSessionReview.body = ''
        $scope.newSessionReview.score = 0
        $location.path "/sessions"
        toaster.pop 'success', '', 'Review submitted successfully', 5000
    ), (errorKey) ->
       $location.path "/error/#{errorKey}"

  $scope.goodReview = (score) ->
    score >= 7

  $scope.poorReview = (score) ->
    score > 3 and score < 7

  $scope.badReview = (score) ->
    score <= 3

  $scope.loadProfileSummary = () ->
    if angular.isUndefined($scope.session.profile)
      SessionsService.authorsProfile($routeParams.id).then (profile) ->
        $scope.session.profile = profile

  $scope.isEmpty = (value) ->
    (value is null) or (value is '')

  $scope.isAcceptedReview = (status) ->
    status is 'accepted'

  $scope.isRejectedReview = (status) ->
    status is 'rejected'

  $scope.isPendingReview = (status) ->
    status is 'pending'
]