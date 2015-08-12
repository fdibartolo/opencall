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

      deferred.reject message

    deferred.promise

  accept = (sessionProposalId, body) ->
    postAction "/notifications/#{sessionProposalId}/accept", body

  decline = (sessionProposalId, body) ->
    postAction "/notifications/#{sessionProposalId}/decline", body

  postAction = (url, body) ->
    deferred = $q.defer()

    $http.post(url,
      body: body
    ).success((data, status) ->
      deferred.resolve()
    ).error (data, status, header, config) ->
      switch status
        when 400 then message = "session_not_found"
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

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

      deferred.reject message

    deferred.promise

  acceptanceTemplate = (sessionProposalId) ->
    getAction "/notifications/#{sessionProposalId}/acceptance_template"

  denialTemplate = (sessionProposalId) ->
    getAction "/notifications/#{sessionProposalId}/denial_template"

  getAction = (url) ->
    deferred = $q.defer()

    $http.get(url)
    .success((data, status) ->
      deferred.resolve data
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
  acceptanceTemplate: acceptanceTemplate
  denialTemplate: denialTemplate
]