angular.module('openCall.services').factory 'StatsService', 
['$q', '$http', ($q, $http) ->

  all = () ->
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

  get = (theme) ->
    deferred = $q.defer()

    data = [
      {
        name: 'Enterprise Agile'
        proposals: [
          {
            name: 'proposal 2asd asd asdasd asd asdasdasd asd asd asdasd'
            reviews: [10,9,8]
          }
          {
            name: 'proposal 3'
            reviews: [4,1,3]
          }
          {
            name: 'proposal 1'
            reviews: [4,8]
          }
          {
            name: 'proposal 10'
            reviews: []
          }
        ]
      }
      {
        name: 'Liderazgo y aprendizaje'
        proposals: [
          {
            name: 'proposal 4'
            reviews: [4,8,6]
          }
          {
            name: 'proposal 5'
            reviews: [10,8,9]
          }
          {
            name: 'proposal 6'
            reviews: [4,1,3]
          }
        ]
      }
      {
        name: 'Cultura y colaboración'
        proposals: [
          {
            name: 'proposal 7'
            reviews: [4,8,6]
          }
          {
            name: 'proposal 8'
            reviews: [10,8,9]
          }
          {
            name: 'proposal 9'
            reviews: [4,1,3]
          }
        ]
      }
    ]

    # MUST be sort by number of reviews!!!!!
    result = d for d in data when d.name is theme
    deferred.resolve result

    deferred.promise

  all: all
  get: get
]