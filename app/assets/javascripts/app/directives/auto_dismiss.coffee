angular.module("openCall.directives").directive "autoDismiss", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    if attrs.autoDismiss isnt ""
      $timeout (->
        $(element).fadeOut 1000
        return
      ), attrs.autoDismiss

    return
]
