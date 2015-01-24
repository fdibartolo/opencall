angular.module("openCall.directives").directive "tagSuggestion", ->
  return (
    restrict: "A"
    replace: false
    scope: false
    
    link: (scope, elem, attrs) ->

      updateModel = (object, suggestion, dataset) ->
        scope.$apply ->
          scope.newSession.tags.push suggestion.text
          return
        return

      engine = new Bloodhound(
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace("name")
        queryTokenizer: Bloodhound.tokenizers.whitespace
        limit: 10
        # prefetch: "/tags"
        remote:
          url: "/tags/suggest?q={0}"
          replace: (url, query) ->
            url.replace "{0}", query
      )

      engine.initialize()
      $(elem).typeahead
        hint: true
        highlight: true
        minLength: 1
      ,
        name: "engine"
        displayKey: "text"
        source: engine.ttAdapter()

      elem.bind "typeahead:selected", (object, suggestion, dataset) ->
        updateModel object, suggestion, dataset
        elem.val ""
        return

      elem.bind "typeahead:autocompleted", (object, suggestion, dataset) ->
        updateModel object, suggestion, dataset
        elem.val ""
        return

      elem.bind "blur", ->
        elem.val ""
        return

      elem.bind "keypress", (event) ->
        regex = new RegExp("^[a-zA-Z0-9.\\-_]+$")
        charCode = ((if not event.charCode then event.which else event.charCode))
        key = String.fromCharCode(charCode)
        
        # avoid backspace problem on firefox
        if charCode isnt 8
          if not regex.test(key) or (key is String.fromCharCode(0))
            event.preventDefault()
            false

        # possibly a new tag
        if charCode is 13
          tag = 
            text: elem.val()
          updateModel null, tag, null
          elem.val ""

      return
  )
