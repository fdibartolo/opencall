angular.module('openCall.services').factory 'SessionsService', 
['$q', '$http', ($q, $http) ->

  all = (credentials) ->
    deferred = $q.defer()

    $http.get("/session_proposals")
    .success((data, status) ->
      deferred.resolve data
    ).error (data, status) ->
      deferred.reject

    deferred.promise

  all: all
]
