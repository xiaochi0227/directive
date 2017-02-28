ecamsApp.directive 'uiSearchBox', ['$timeout',($timeout) ->
  {
    restrict: 'E',
    templateUrl:'../../views/tmpl/directive-ui-search-box-tmpl.html',
    replace:true,
    scope:{
      keys:"=searchKey",
      disableFilter:"=",
      searchCallBack:"&"
    },
    link: (scope, element, attr) ->

      scope.searchBox = {
        searchValue:null,
        searchKey:null,
        serachValueText:null
      }

      scope.chooseSearchValue = (_value)->
        scope.searchBox.searchValue = _value;
        if scope.searchBox.searchKey.type is 'list'
          scope.searchBox.serachValueText = _value.text
        else if scope.searchBox.searchKey.type is 'text'
          scope.searchBox.serachValueText = _value

      scope.chooseSearchKey = (_key)->
        scope.searchBox.searchKey = _key
        scope.searchBox.serachValueText = null
        scope.searchBox.searchValue = null

      scope.submitSearch = ()->
        if not scope.searchBox.searchValue
          return 
        searchObj = {
          key:scope.searchBox.searchKey,
          value:scope.searchBox.searchValue
        }
        scope.searchCallBack?({result:searchObj});
        return
      return
  }
]
