angular.module("openCall.directives").directive "rubberBandAnimation", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    scope.$watch attrs.rubberBandAnimation, (count) ->
      if count is 0
        $(element).removeClass('animated rubberBand').addClass('text-muted')
      else
        $(element).removeClass('animated rubberBand')
        $timeout (->
          $(element).addClass('animated rubberBand')
          return
        ), 100

      return
    return
]
