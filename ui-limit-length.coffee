ecamsApp.directive 'uiLimitLength', ->
  {
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
      attrs.$set 'ngTrim', 'false'
      limitLength = parseInt(attrs.uiLimitLength, 10) 
      
      scope.limit_length = (str, len, hasDot) ->
        newLength = 0
        newStr = ''
        chineseRegex = /[^\x00-\xff]/g
        singleChar = ''
        strLength = str.replace(chineseRegex,"**").length;
        i = 0
        while i < strLength
          singleChar = str.charAt(i).toString()
          if singleChar.match(chineseRegex) != null
            newLength += 2
          else
            newLength++
          if newLength > len
            break
          newStr += singleChar
          i++
        return newStr

      scope.$watch attrs.ngModel, (newValue) ->
        viewValue = ngModel.$viewValue
        if not viewValue or viewValue is ''
          return
        ngModel.$setViewValue scope.limit_length(viewValue,limitLength)
        ngModel.$render()
        return
      return

  }