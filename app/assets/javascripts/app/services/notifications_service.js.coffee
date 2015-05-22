angular.module('openCall.services').factory 'NotificationsService', 
['$q', '$http', ($q, $http) ->

  sessions = () ->
    deferred = $q.defer()

    $http.get("/notifications")
    .success((data, status) ->
      deferred.resolve data.sessions
    ).error (data, status, header, config) ->
      switch status
        when 403 then message = "access_denied"
        else message = "generic"

    deferred.promise

  sessions: sessions
]