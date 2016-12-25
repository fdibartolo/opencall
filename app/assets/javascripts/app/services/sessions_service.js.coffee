angular.module('openCall.services').factory 'SessionsService', 
['$q', '$http', ($q, $http) ->

  all = () ->
    deferred = $q.defer()

    $http.get("/session_proposals").then (response) ->
      deferred.resolve response.data
    , (response) ->
      deferred.reject()

    deferred.promise

  create = (session) ->
    deferred = $q.defer()

    $http.post("/session_proposals", 
      session_proposal:
        title: session.title
        theme_id: session.theme_id
        track_id: session.track_id
        audience_id: session.audience_id
        audience_count: session.audience_count
        summary: session.summary
        description: session.description
        video_link: session.video_link
        tags_attributes: buildNestedAttributesFor(session.tags)
    ).then (response) ->
      headers = response.headers
      deferred.resolve headers()["id"]
    , (response) ->
      switch response.status
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  update = (session) ->
    deferred = $q.defer()

    $http.put("/session_proposals/#{session.id}",
      session_proposal:
        title: session.title
        theme_id: session.theme_id
        track_id: session.track_id
        audience_id: session.audience_id
        audience_count: session.audience_count
        summary: session.summary
        description: session.description
        video_link: session.video_link
        tags_attributes: buildNestedAttributesFor(session.tags)
    ).then (response) ->
      deferred.resolve()
    , (response) ->
      headers = response.headers
      switch response.status
        when 400 then message = sanitize(headers()["message"])
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  buildNestedAttributesFor = (tags) ->
    result = []
    angular.forEach tags, (tag) ->
      result.push { id: tag.id, name: tag.name, _destroy: tag._destroy }
    result

  search = (terms, pageNumber) ->
    deferred = $q.defer()

    $http.get("/session_proposals/search?q=#{terms}&page=#{pageNumber}").then (response) ->
      deferred.resolve response.data
    , (response) ->
      deferred.reject()

    deferred.promise

  show = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/#{id}").then (response) ->
      deferred.resolve response.data
    , (response) ->
      headers = response.headers
      message = if response.status is 400 then sanitize(headers()["message"]) else "generic"
      deferred.reject message

    deferred.promise

  get = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/#{id}/edit").then (response) ->
      deferred.resolve response.data
    , (response) ->
      headers = response.headers
      switch response.status
        when 400 then message = sanitize(headers()["message"])
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  sanitize = (message) ->
    return "session_not_found"  if message.indexOf("Unable to find session proposal with id") is 0

  new_session = () ->
    deferred = $q.defer()

    $http.get("/session_proposals/new").then (response) ->
      deferred.resolve response.data
    , (response) ->
      deferred.reject()

    deferred.promise

  authorsProfile = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/#{id}/author").then (response) ->
      deferred.resolve response.data
    , (response) ->
      deferred.reject()

    deferred.promise

  all: all
  create: create
  update: update
  search: search
  show: show
  get: get
  new: new_session
  authorsProfile: authorsProfile
]
