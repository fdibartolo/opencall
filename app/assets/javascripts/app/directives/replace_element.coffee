angular.module("openCall.directives").directive 'replaceElement', ->
  require: 'ngInclude'
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.replaceWith element.children()
    return
