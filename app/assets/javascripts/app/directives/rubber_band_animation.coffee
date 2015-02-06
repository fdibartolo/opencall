angular.module("openCall.directives").directive "rubberBandAnimation", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    scope.$watch attrs.rubberBandAnimation, (count) ->
      $(element).removeClass('animated rubberBand')
      $timeout (->
        $(element).addClass('animated rubberBand')
        return
      ), 100

      return
    return
]
