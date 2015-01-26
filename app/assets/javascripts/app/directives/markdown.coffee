angular.module("openCall.directives").directive "markdown", ->
  return (
    restrict: "A"
    replace: true

    link: (scope, element, attrs) ->
      marked.setOptions
        renderer: new marked.Renderer()
        gfm: true
        tables: true
        breaks: false
        pedantic: false
        sanitize: true
        smartLists: true
        smartypants: false
        breaks: true

      scope.$watch attrs.markdown, (text) ->
        element.html marked(text or "", null)

      return
  )