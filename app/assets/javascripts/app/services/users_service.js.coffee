angular.module('openCall.services').factory 'UsersService', 
['$q', '$http', ($q, $http) ->

  all = (id) ->
    deferred = $q.defer()

    $http.get("/users/session_proposals")
    .success((data, status) ->
      console.log data.sessions
      deferred.resolve data.sessions
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  all: all
]