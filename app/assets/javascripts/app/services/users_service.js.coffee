angular.module('openCall.services').factory 'UsersService', 
['$q', '$http', ($q, $http) ->

  user_sessions = (id) ->
    deferred = $q.defer()

    $http.get("/users/session_proposals")
    .success((data, status) ->
      deferred.resolve data.sessions
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  user_reviews = (id) ->
    deferred = $q.defer()

    $http.get("/users/reviews")
    .success((data, status) ->
      deferred.resolve data.reviews
    ).error (data, status, header, config) ->
      switch status
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  user_session_voted_ids = () ->
    deferred = $q.defer()

    $http.get("/users/session_voted_ids")
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  toggle_vote_session = (id, vote) ->
    deferred = $q.defer()

    $http.post("/users/vote_session",
      id: id
      vote: vote
    ).success((data, status) ->
      deferred.resolve data
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  user_sessions: user_sessions
  user_reviews: user_reviews
  user_session_voted_ids: user_session_voted_ids
  toggle_vote_session: toggle_vote_session
]