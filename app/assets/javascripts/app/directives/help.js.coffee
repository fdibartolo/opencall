angular.module("openCall.directives").directive "helpable", ->
  link: (scope, element, attrs) ->
    element.addClass('helpable')

    [placement, content] = attrs.helpable.split "|"

    if angular.isUndefined(attrs.index) or (angular.isDefined(attrs.index) and attrs.index is "0")
      element.popover(
        trigger: 'manual'
        content: content
        placement: placement
      )
    return

angular.module("openCall.directives").directive "toggleHelp", ->
  link: (scope, element, attrs) ->
    helpVisible = false
    element.bind "click", ->
      helpVisible = !helpVisible
      action = if helpVisible then 'show' else 'hide'
      $('.helpable').popover action
      return
    return
