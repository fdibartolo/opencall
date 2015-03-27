angular.module('openCall.services').factory 'StatsService', 
['$q', '$http', ($q, $http) ->

  all = (id) ->
    deferred = $q.defer()

    data = [
      {
        name: 'Enterprise Agile'
        count: 15
        reviewed: 12
      }
      {
        name: 'Liderazgo y aprendizaje'
        count: 11
        reviewed: 7
      }
      {
        name: 'Cultura y colaboración'
        count: 8
        reviewed: 1
      }
      {
        name: 'DevOps & Entrega continua'
        count: 6
        reviewed: 0
      }
      {
        name: 'Prácticas de desarrollo y pruebas automatizadas'
        count: 1
        reviewed: 1
      }
      {
        name: 'Experiencia de usuario'
        count: 3
        reviewed: 2
      }
      {
        name: 'Uso de agile fuera del desarrollo de software'
        count: 6
        reviewed: 4
      }
      {
        name: 'Innovación'
        count: 10
        reviewed: 10
      }
      {
        name: 'Startups & Emprendimiento'
        count: 7
        reviewed: 3
      }
    ]

    deferred.resolve data

    deferred.promise

    # deferred = $q.defer()

    # $http.get("/session_proposals/#{id}/comments")
    # .success((data, status) ->
    #   deferred.resolve data.comments
    # ).error (data, status) ->
    #   deferred.reject()

    # deferred.promise

  all: all
]