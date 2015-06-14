angular.module('openCall.services').factory 'NotificationsService', 
['$q', '$http', ($q, $http) ->

  sessions = () ->
    deferred = $q.defer()

    $http.get("/notifications")
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status, header, config) ->
      switch status
        when 403 then message = "access_denied"
        else message = "generic"

    deferred.promise

  accept = (sessionProposalId) ->
    postAction "/notifications/#{sessionProposalId}/accept"

  decline = (sessionProposalId) ->
    postAction "/notifications/#{sessionProposalId}/decline"

  submitMessage = (message) ->
    deferred = $q.defer()

    $http.post("/notifications/notify_authors",
      message:
        subject: message.subject
        body: message.body
    ).success((data, status, header, config) ->
      deferred.resolve()
    ).error (data, status, header, config) ->
      switch status
        when 403 then message = "access_denied"
        else message = "generic"

    deferred.promise

  postAction = (url) ->
    deferred = $q.defer()

    $http.post(url)
    .success((data, status) ->
      deferred.resolve()
    ).error (data, status, header, config) ->
      switch status
        when 400 then message = "session_not_found"
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  sessions: sessions
  accept: accept
  decline: decline
  submitMessage: submitMessage
]