angular.module("openCall.directives").directive "timeFromNow", ->
  return (
    restrict: "A"
    replace: true

    link: (scope, element, attrs) ->
      scope.$watch attrs.timeFromNow, (date) ->
        element.html moment(date).fromNow()

      return
  )
