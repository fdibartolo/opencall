angular.module("openCall.directives").directive "confirmClick", ->
  link: (scope, element, attr) ->
    msg = attr.confirmClick or "Are you sure?"
    clickAction = attr.confirmedAction
    element.bind "click", (event) ->
      if window.confirm msg
        scope.$eval clickAction
      return
    return
