angular.module('openCall.services').factory 'ReviewsService', 
['$q', '$http', ($q, $http) ->

  all = (id) ->
    deferred = $q.defer()

    $http.get("/session_proposals/#{id}/reviews")
    .success((data, status) ->
      deferred.resolve data.reviews
    ).error (data, status, header, config) ->
      switch status
        when 400 then message = "session_not_found"
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  create = (id, review) ->
    deferred = $q.defer()

    $http.post("/session_proposals/#{id}/reviews",
      review:
        body: review.body
        private_body: review.private_body
        score: review.score.value
        second_reviewer_id: review.secondReviewer.id
    ).success((data, status) ->
      deferred.resolve()
    ).error (data, status, header, config) ->
      switch status
        when 400 then message = "session_not_found"
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  accept = (sessionProposalId, reviewId) ->
    postAction "/session_proposals/#{sessionProposalId}/reviews/#{reviewId}/accept"

  reject = (sessionProposalId, reviewId) ->
    postAction "/session_proposals/#{sessionProposalId}/reviews/#{reviewId}/reject"

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

  all: all
  create: create
  accept: accept
  reject: reject
]