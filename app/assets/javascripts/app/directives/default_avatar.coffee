angular.module("openCall.directives").directive "defaultAvatarIfError", () ->
  link: (scope, element, attrs) ->
    element.bind "error", ->
      attrs.$set('src', DEFAULT_AVATAR_URL)
      return
    return  
