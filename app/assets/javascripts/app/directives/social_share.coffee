angular.module("openCall.directives").directive "tweet", ['$window', '$timeout', ($window, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.parent().prepend "<span class='fa fa-spinner fa-pulse fa-3x fa-fw spinner-social-share'></span>"

    renderTweetButton = ->
      element.html "<a href='https://twitter.com/share' class='twitter-share-button' data-show-count='false' 
        data-text='#{attrs.text}' data-url='#{BASE_URL}#/sessions/show/#{attrs.tweet}' 
        data-size='large' data-via='#{attrs.twitterAccount}'>Tweet</a>"
      $window.twttr.widgets.load element.parent()[0]

      $timeout (->
        spinner = element.parent().find('.spinner-social-share')
        angular.element(spinner).remove()
        return
      ), 2000

    if !$window.twttr
      $.getScript '//platform.twitter.com/widgets.js', ->
        renderTweetButton()
        return
    else
      renderTweetButton()
    return
]

angular.module("openCall.directives").directive 'googlePlus', ['$window', '$timeout', ($window, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.parent().prepend "<span class='fa fa-spinner fa-pulse fa-3x fa-fw spinner-social-share'></span>"

    renderPlusButton = ->
      element.html "<div class='g-plus' data-action='share' data-annotation='none' data-height='28' 
        data-href='#{BASE_URL}#/sessions/show/#{attrs.googlePlus}' data-size='medium'></div>"
      $window.gapi.plus.go element.parent()[0]

      $timeout (->
        spinner = element.parent().find('.spinner-social-share')
        angular.element(spinner).remove()
        return
      ), 2000

    if !$window.gapi
      $.getScript '//apis.google.com/js/platform.js', ->
        renderPlusButton()
        return
    else
      renderPlusButton()
    return
]

angular.module("openCall.directives").directive 'facebook', ['$window', '$timeout', ($window, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.parent().prepend "<span class='fa fa-spinner fa-pulse fa-3x fa-fw spinner-social-share'></span>"

    renderShareButton = ->
      element.html "<div class='fb-share-button' data-layout='button' data-size='large'
        data-href='#{BASE_URL}#/sessions/show/#{attrs.facebook}'></div>"
      $window.FB.XFBML.parse element.parent()[0]

      $timeout (->
        spinner = element.parent().find('.spinner-social-share')
        angular.element(spinner).remove()
        return
      ), 2000

    if !$window.FB
      $.getScript '//connect.facebook.net/en_US/sdk.js', ->
        $window.FB.init
          xfbml: true
          version: 'v2.8'
        renderShareButton()
        return
    else
      renderShareButton()
    return
]
