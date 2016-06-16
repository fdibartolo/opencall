angular.module("openCall.directives").directive "animateWith", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    className = attrs.animateWith
    $(element).addClass("animated #{className}")
    $timeout (->
      $(element).removeClass('animated')
      return
    ), 1000
    return
]
