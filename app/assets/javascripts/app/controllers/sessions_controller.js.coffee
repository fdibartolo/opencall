angular.module('openCall.controllers').controller 'SessionsController', 
['$scope', '$location', '$routeParams', 'SessionsService', 'CommentsService', 
($scope, $location, $routeParams, SessionsService, CommentsService) ->

  $scope.sessions = []
  $scope.matched_tags = []
  $scope.total = 0
  $scope.newSession = 
    title: ''
    description: ''
    tags: []
  $scope.availableVotes = 10
  $scope.searchTerms = ''
  $scope.searchPageNumber = 1
  $scope.newSessionComment = 
    body: ''
    date: null

  $scope.init = () ->
    $scope.loading = true
    SessionsService.all().then (response) ->
      $scope.sessions = response.sessions
      $scope.total = response.total
      $scope.loading = false

  $scope.createSession = () ->
    SessionsService.create($scope.newSession).then () ->
      $location.path '/sessions'

  $scope.search = (termToAdd) ->
    $scope.loading = true
    $scope.searchTerms = "#{$scope.searchTerms} #{termToAdd}"  if angular.isDefined(termToAdd)
    $scope.searchPageNumber = 1 # reset page number
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      $scope.sessions     = response.sessions
      $scope.matched_tags = response.matched_tags
      $scope.total        = response.total
      $scope.loading = false

  $scope.loadMore = () ->
    $scope.searchPageNumber += 1
    SessionsService.search($scope.searchTerms, $scope.searchPageNumber).then (response) ->
      angular.forEach response.sessions, (session) ->
        $scope.sessions.push session

  $scope.vote = (index) ->
    $scope.sessions[index].voted = false  if angular.isUndefined($scope.sessions[index].voted)
    $scope.sessions[index].voted = !$scope.sessions[index].voted
    delta = if $scope.sessions[index].voted then -1 else 1
    $scope.availableVotes += delta  if $scope.availableVotes isnt 0 or delta is 1

  $scope.fav = (index) ->
    $scope.sessions[index].faved = false  if angular.isUndefined($scope.sessions[index].faved)
    $scope.sessions[index].faved = !$scope.sessions[index].faved

  $scope.removeTag = (index) ->
    $scope.newSession.tags.splice index, 1

  $scope.show = () ->
    SessionsService.show($routeParams.id).then ((session) ->
      $scope.session = session
      CommentsService.all($routeParams.id).then (comments) ->
        $scope.session.comments = comments
    ), (errorKey) ->
      $location.path '/error/' + errorKey

  $scope.postComment = () ->
    CommentsService.create($routeParams.id, $scope.newSessionComment).then () ->
      comment = 
        body: $scope.newSessionComment.body
        author:
          avatar_url: CURRENT_USER_AVATAR
        date: moment()
      $scope.session.comments.push comment
      $scope.newSessionComment.body = ''
      $scope.newSessionComment.date = null
]