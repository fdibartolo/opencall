angular.module("openCall.directives").directive "favAction", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    $(element).addClass('fa text-warning')
    scope.$watch 'session.faved', (faved) ->
      if faved
        $(element).removeClass('fa-star-o')
        $(element).addClass('fa-star animated tada')
        $timeout (->
          $(element).removeClass('animated tada')
          return
        ), 1000
      else
        $(element).removeClass('fa-star')
        $(element).addClass('fa-star-o')

      return

    element.bind "click", ->
      scope.$apply ->
        scope.fav(attrs.index)
        return
      return

    return
]

angular.module("openCall.directives").directive "voteAction", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    $(element).addClass('fa text-success')
    scope.$watch 'session.voted', (voted) ->
      if voted
        $(element).removeClass('fa-circle-o')
        $(element).addClass('fa-check-circle animated rubberBand')
        $timeout (->
          $(element).removeClass('animated rubberBand')
          return
        ), 1000
      else
        $(element).removeClass('fa-check-circle')
        $(element).addClass('fa-circle-o')

      return

    element.bind "click", ->
      scope.$apply ->
        scope.vote(attrs.index)
        return
      return

    return
]
