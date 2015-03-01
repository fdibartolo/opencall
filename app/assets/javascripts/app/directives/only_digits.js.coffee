angular.module("openCall.directives").directive "onlyDigits", ->
  restrict: "A"
  require: "?ngModel"
  link: (scope, element, attrs, ngModelController) ->
    return  unless ngModelController
    ngModelController.$parsers.unshift (inputValue) ->
      digits = inputValue.split("").filter((s) ->
        not isNaN(s) and s isnt " "
      ).join("")
      ngModelController.$viewValue = digits
      ngModelController.$render()
      digits

    return
