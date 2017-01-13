angular.module('openCall.controllers').controller 'NotificationsController', 
['$scope', '$location', '$window', 'constants', 'NotificationsService', 'toaster', ($scope, $location, $window, constants, NotificationsService, toaster) ->

  $scope.newMessage =
    subject: ''
    body: ''

  $scope.init = () ->
    $scope.sort = constants.notifications.sort.top

    $scope.$emit 'showLoadingSpinner', 'Loading...'
    NotificationsService.sessions().then ((response) ->
      $scope.sessions = response.sessions
      $scope.themes = []
      angular.forEach response.themes, (themeName) ->
        theme =
          name: themeName
          active: true
        $scope.themes.push theme
      $scope.$emit 'hideLoadingSpinner'
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.acceptSession = (session) ->
    $scope.$emit 'showLoadingSpinner', 'Accepting and notifying...'
    NotificationsService.accept(session.id, $scope.notificationData.body).then (() ->
      session.status      = constants.sessions.status.accepted
      session.notified_on = moment().format()
      $scope.$emit 'hideLoadingSpinner'
      $window.location.reload()
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.declineSession = (session) ->
    $scope.$emit 'showLoadingSpinner', 'Declining and notifying...'
    NotificationsService.decline(session.id, $scope.notificationData.body).then (() ->
      session.status      = constants.sessions.status.declined
      session.notified_on = moment().format()
      $scope.$emit 'hideLoadingSpinner'
      $window.location.reload()
    ), (errorKey) ->
      $location.path "/error/#{errorKey}"
      $scope.$emit 'hideLoadingSpinner'

  $scope.getAcceptanceTemplateFor = (session) ->
    if angular.isDefined(session)
      $scope.isAcceptanceTemplate = true
      $scope.isDenialTemplate     = false
      $scope.sessionToNotify = session
      NotificationsService.acceptanceTemplate(session.id).then ((data) ->
        $scope.notificationData = 
          body: data.template
          feedback: data.feedback
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

  $scope.getDenialTemplateFor = (session) ->
    if angular.isDefined(session)
      $scope.isAcceptanceTemplate = false
      $scope.isDenialTemplate     = true
      $scope.sessionToNotify = session
      NotificationsService.denialTemplate(session.id).then ((data) ->
        $scope.notificationData = 
          body: data.template
          feedback: data.feedback
      ), (errorKey) ->
        $location.path "/error/#{errorKey}"

  $scope.submitMessage = () ->
    $scope.$emit 'showLoadingSpinner', 'Sending message...'
    NotificationsService.submitMessage($scope.newMessage).then (() ->
      $scope.newMessage.subject = ''
      $scope.newMessage.body    = ''
      $scope.$emit 'hideLoadingSpinner'
      toaster.pop 'success', '', 'Message to all authors submitted successfully', 5000
    ), (errorKey) ->
      $scope.$emit 'hideLoadingSpinner'
      $location.path "/error/#{errorKey}"

  $scope.tweet = () ->
    $scope.tweeting = true
    NotificationsService.tweet($scope.sessionId, $scope.tweetMessage).then (() ->
      $scope.tweeting = false
      $scope.$emit 'hideTweetDialog'
      toaster.pop 'success', '', 'Tweet posted successfully', 5000
    ), (errorKey) ->
      $scope.tweeting = false
      $scope.$emit 'hideTweetDialog'
      $location.path "/error/#{errorKey}"

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    
  $scope.isVisibleTheme = (themeName) ->
    t = theme for theme in $scope.themes when theme.name is themeName
    t.active

  $scope.toggleSort = () ->
    if $scope.isTopSort()
      $scope.sort = constants.notifications.sort.bottom
    else
      $scope.sort = constants.notifications.sort.top

  $scope.isTopSort = () ->
    $scope.sort.type is constants.notifications.sort.top.type
    
  $scope.isBottomSort = () ->
    $scope.sort.type is constants.notifications.sort.bottom.type
    
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

  $scope.isNewSession = (status) ->
    status is constants.sessions.status.new

  $scope.isAcceptedSession = (status) ->
    status is constants.sessions.status.accepted

  $scope.isDeclinedSession = (status) ->
    status is constants.sessions.status.declined
]