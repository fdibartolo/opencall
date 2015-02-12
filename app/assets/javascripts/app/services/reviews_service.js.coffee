angular.module('openCall.services').factory 'ReviewsService', 
['$q', '$http', ($q, $http) ->

  create = (id, review) ->
    deferred = $q.defer()

    $http.post("/session_proposals/" + id + "/reviews"
      review:
        body: review.body
        score: review.score
    ).success((data, status) ->
      deferred.resolve()
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  create: create
]