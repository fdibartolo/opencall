angular.module("openCall.directives").directive "setSelected", ->
  link: (scope, element, attrs) ->
    scope.$watch attrs.setSelected, (value) ->
      angular.forEach element.find('select > option'), (opt) ->
        el = angular.element(opt)
        el.remove()  unless el.attr('value').indexOf('?') is -1
        el.attr('selected','selected')  if parseInt(el.attr('value')) is value
    return
