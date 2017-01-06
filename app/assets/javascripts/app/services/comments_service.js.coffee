angular.module('openCall.services').factory 'CommentsService', 
['$q', '$http', ($q, $http) ->

  all = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/#{id}/comments").then (response) ->
      deferred.resolve response.data.comments
    , (response) ->
      deferred.reject()

    deferred.promise

  create = (id, comment) ->
    deferred = $q.defer()

    $http.post("/session_proposals/#{id}/comments",
      comment:
        body: comment.body
    ).then (response) ->
      deferred.resolve()
    , (response) ->
      deferred.reject()

    deferred.promise

  all: all
  create: create
]