angular.module('openCall.services').factory 'CommentsService', 
['$q', '$http', ($q, $http) ->

  all = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/" + id + "/comments")
    .success((data, status) ->
      deferred.resolve data.comments
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  create = (id, comment) ->
    deferred = $q.defer()

    $http.post("/session_proposals/" + id + "/comments"
      comment:
        body: comment.body
    ).success((data, status) ->
      deferred.resolve()
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  all: all
  create: create
]