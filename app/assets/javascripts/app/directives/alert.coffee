angular.module("openCall.directives").directive "alert", ['$timeout', 'toaster', ($timeout, toaster) ->
  link: (scope, element, attrs) ->
    $timeout (->
      toaster.pop attrs.alertType, '', attrs.alert, 5000
      return
    ), 500

    return
]
