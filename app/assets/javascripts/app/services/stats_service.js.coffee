angular.module('openCall.services').factory 'StatsService', 
['$q', '$http', ($q, $http) ->

  all = () ->
    deferred = $q.defer()

    $http.get("/stats")
    .success((data, status) ->
      deferred.resolve data.themes
    ).error (data, status) ->
      deferred.reject()

    deferred.promise

  get = (id) ->
    deferred = $q.defer()

    $http.get("/stats/#{id}")
    .success((data, status) ->
      data.proposals.sort sortByReviewsCount
      deferred.resolve data
    ).error (data, status, header, config) ->
      switch status
        when 400 then message = "theme_not_found"
        when 403 then message = "access_denied"
        else message = "generic"

      deferred.reject message

    deferred.promise

  sortByReviewsCount = (a, b) ->
    return -1  if a.reviews.length > b.reviews.length
    return 1  if a.reviews.length < b.reviews.length
    return 0

  all: all
  get: get
]