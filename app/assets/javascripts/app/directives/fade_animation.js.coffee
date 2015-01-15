angular.module("openCall.directives").directive "fadeAnimation", ['$timeout', ($timeout) ->
  link: (scope, element, attrs) ->
    if attrs.fadeAnimation isnt ""
      scope.$watch attrs.fadeAnimation, (value) ->
        if value is true
          $(element).hide()
          $(element).fadeIn 1000

          if attrs.autoClose > 0
            $timeout (->
              $(element).fadeOut 1000
              return
            ), attrs.autoClose
        else
          $(element).hide()  if attrs.hide isnt "false"
        return

    return
]
