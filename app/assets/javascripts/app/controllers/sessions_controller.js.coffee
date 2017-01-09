angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', '$location', '$routeParams', '$window', 'toaster', 'SessionsService', 'CommentsService', 'UsersService',
($scope, $location, $routeParams, $window, toaster, SessionsService, CommentsService, UsersService) ->

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
  $scope.searchPageNumber = 1
  $scope.newSessionComment = 
    body: ''
    date: null

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
      SessionsService.create($scope.newSession).then ((id) ->
        $location.path "/sessions/show/#{id}"
        $scope.$emit 'hideLoadingSpinner'
        $scope.$emit 'showTweetDialog', "#{BASE_URL}#/sessions/show/#{id}"
        toaster.pop 'success', '', 'Session proposal submitted successfully', 5000
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

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
    $scope.newSession.invalidVideo       = $scope.newSession.video_link is ''

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
        $window.sessionStorage.setItem 'availableVotes', $scope.availableVotes
      UsersService.user_session_faved_ids().then (ids) ->
        $scope.sessionFavedIds = ids

  $scope.initSearch = () ->
    cached = $window.sessionStorage.getItem 'searchFor'
    $scope.searchTerms = if angular.isDefined(cached) and cached isnt null then cached else ''
    $scope.search()

  $scope.search = (termToAdd) ->
    $scope.loading = true
    $scope.searchTerms = "#{$scope.searchTerms} #{termToAdd}"  if angular.isDefined(termToAdd)
    $scope.searchPageNumber = 1 # reset page number
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      $scope.sessions     = addVotedAndFavedStatusFor(response.sessions)
      $scope.matched_tags = response.matched_tags  unless $scope.searchTerms is ''
      $scope.total        = response.total
      $scope.loading      = false
      $window.sessionStorage.setItem 'searchFor', $scope.searchTerms

  addVotedAndFavedStatusFor = (sessions) ->
    angular.forEach sessions, (session) ->
      session.voted = $scope.sessionVotedIds.indexOf(session.id) isnt -1
      session.faved = $scope.sessionFavedIds.indexOf(session.id) isnt -1
      session.tagsVisible = false
      session.shareVisible = false
    sessions

  $scope.loadMore = () ->
    $scope.searchPageNumber += 1
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      angular.forEach response.sessions, (session) ->
        session.voted = $scope.sessionVotedIds.indexOf(session.id) isnt -1
        session.faved = $scope.sessionFavedIds.indexOf(session.id) isnt -1
        $scope.sessions.push session

  $scope.vote = (id) ->
    if angular.isDefined($scope.session)
      session = $scope.session
    else
      id = parseInt(id)
      session = s for s in $scope.sessions when s.id is id
    if angular.isDefined(session)
      session.voted = false  if angular.isUndefined(session.voted)
      session.voted = !session.voted

      UsersService.toggle_vote_session(session.id, session.voted).then () ->
        delta = if session.voted then -1 else 1
        $scope.availableVotes += delta  if $scope.availableVotes isnt 0 or delta is 1
        $window.sessionStorage.setItem 'availableVotes', $scope.availableVotes

        if delta is -1 and $scope.availableVotes < 4
          switch $scope.availableVotes
            when 3,2 then message = "You have #{$scope.availableVotes} votes left to use"
            when 1 then message = "You just have 1 vote left"
            else message = "You have no votes left, you can still remove a vote and reassign it if you change your mind"

          toaster.pop('warning', '', message, 7000)

  $scope.fav = (id) ->
    if angular.isDefined($scope.session)
      session = $scope.session
    else
      id = parseInt(id)
      session = s for s in $scope.sessions when s.id is id
    if angular.isDefined(session)
      session.faved = false  if angular.isUndefined(session.faved)
      session.faved = !session.faved

      UsersService.toggle_fav_session(session.id)

  $scope.removeTag = (index) ->
    $scope.newSession.tags[index]._destroy = true

  $scope.show = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
      $scope.availableVotes = parseInt($window.sessionStorage.getItem 'availableVotes')
      CommentsService.all($routeParams.id).then (comments) ->
        $scope.session.comments = comments
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"

  $scope.postComment = () ->
    if $scope.newSessionComment.body isnt ''
      $scope.$emit 'showLoadingSpinner', 'Commenting...'
      CommentsService.create($routeParams.id, $scope.newSessionComment).then () ->
        comment = 
          body: $scope.newSessionComment.body
          author:
            name: CURRENT_USER_NAME
            avatar_url: CURRENT_USER_AVATAR
            is_reviewer: IS_CURRENT_USER_REVIEWER
          date: moment()
        $scope.session.comments.push comment
        $scope.newSessionComment.body = ''
        $scope.newSessionComment.date = null
        $scope.$emit 'hideLoadingSpinner'
]