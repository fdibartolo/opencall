angular.module("openCall.directives").directive "infiniteScroll", ->
  link: (scope, element, attr) ->
    raw = element[0]
    performAction = () ->
      rectObject = raw.getBoundingClientRect()
      scope.$apply attr.infiniteScroll  if rectObject.bottom is window.innerHeight
      return

    angular.element(window).bind "scroll load", performAction
    return
