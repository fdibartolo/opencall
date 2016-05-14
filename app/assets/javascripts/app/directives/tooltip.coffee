angular.module("openCall.directives").directive "tooltip", ->
  link: (scope, element, attrs) ->
    [placement, title] = attrs.tooltip.split "|"

    element.tooltip(
      placement: placement
      title: title
    )
    return
