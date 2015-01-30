angular.module('openCall.services').factory 'SessionsService', 
['$q', '$http', ($q, $http) ->

  all = () ->
    deferred = $q.defer()

    $http.get("/session_proposals")
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  create = (session) ->
    deferred = $q.defer()

    $http.post("/session_proposals", 
      session_proposal:
        title: session.title
        description: session.description
        tags_attributes: buildNestedAttributesFor(session.tags)
    ).success((data, status) ->
      deferred.resolve()
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  buildNestedAttributesFor = (tags) ->
    result = []
    angular.forEach tags, (tag) ->
      result.push { name: tag }
    result

  search = (terms, pageNumber) ->
    deferred = $q.defer()

    $http.get("/session_proposals/search?q=" + terms + "&page=" + pageNumber)
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  show = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/" + id)
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status, header, config) ->
      message = if status is 400 then sanitize(header()["message"]) else "generic"
      deferred.reject message

    deferred.promise

  sanitize = (message) ->
    return "session_not_found"  if message.indexOf("Unable to find session proposal with id") is 0

  all: all
  create: create
  search: search
  show: show
]
