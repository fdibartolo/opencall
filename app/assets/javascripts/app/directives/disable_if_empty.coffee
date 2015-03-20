angular.module("openCall.directives").directive "disableIfEmpty", ->
  restrict: "A"
  link: (scope, elem, attrs) ->
    elem.bind "input keyup", (event) ->
      if elem.val() is ''
        $(attrs.disableIfEmpty).addClass('disabled')
      else
        $(attrs.disableIfEmpty).removeClass('disabled')
    return
