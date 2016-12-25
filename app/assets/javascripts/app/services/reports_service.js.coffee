angular.module('openCall.services').factory 'ReportsService', 
['$q', '$http', ($q, $http) ->

  reviewerComments = () ->
    deferred = $q.defer()

    $http.get("/session_proposals/reviewer_comments").then (response) ->
      deferred.resolve response.data
    , (response) ->
      switch response.status
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  communityVotes = () ->
    deferred = $q.defer()

    $http.get("/session_proposals/community_votes").then (response) ->
      deferred.resolve response.data
    , (response) ->
      switch response.status
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  reviewerComments: reviewerComments
  communityVotes: communityVotes
]