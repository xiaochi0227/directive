ecamsApp.directive 'uiSearchDateSelect', ['gettext',(gettext) ->
  {
    restrict: 'E',
    templateUrl:'../../views/tmpl/directive-ui-date-search-tmpl.html',
    replace:true,
    scope:{
      minDate:"@",
      selectMonthAll: '@'
      defaultSearch:'@',
      searchOnDefault:"@",
      searchCallBack:"&"
    },
    link: (scope, element, attr) ->
      currDate = new Date();
      currMonth = currDate.getMonth();
      currYear = currDate.getFullYear();
      _yearMonthObj = null;
      scope.years = []
      scope.months = []
      minYear = ''
      minMonth = ''
      minDate = ''
      
      currMonth = if currMonth + 1 < 10 then '0' + (currMonth + 1) else currMonth + 1
      _defaultSearch = if !!scope.defaultSearch then scope.defaultSearch else currYear + '-' + currMonth

      getMonthText = (month)->
        switch month
          when '01' then return gettext('January')
          when '02' then return gettext('February')
          when '03' then return gettext('March')
          when '04' then return gettext('April')
          when '05' then return gettext('May')
          when '06' then return gettext('June')
          when '07' then return gettext('July')
          when '08' then return gettext('August')
          when '09' then return gettext('September')
          when '10' then return gettext('October')
          when '11' then return gettext('November')
          when '12' then return gettext('December')
        return

      scope.search = {
        year: +_defaultSearch.split('-')[0]
        month:{
          key: _defaultSearch.split('-')[1]
          text:getMonthText(_defaultSearch.split('-')[1])
        }
      }
      if scope.searchOnDefault and scope.searchOnDefault == 'true' and scope.search
        scope.searchCallBack({result:scope.search})

      initSearchDate = ()->
        _yearMonthObj = {}
        for year in [minYear...currYear + 1]
          scope.years.push year
          _yearMonthObj[year] = []
          _startMonth = 0
          _endMonth = 0
          if +year is +currYear
            if +currYear is +minYear
              _startMonth = minMonth
            else 
              _startMonth = 1
            _endMonth = parseInt(currMonth)  + 1
          else if +year is +minYear
            _startMonth = minMonth
            _endMonth = 12 + 1
          else
            _startMonth = 1
            _endMonth = 12 + 1
          for month in [_startMonth..._endMonth]
            _month = if month < 10 then '0' + month else month + ''
            _yearMonthObj[year].push {key:_month,text:getMonthText(_month)}
          if !!scope.selectMonthAll
            _yearMonthObj[year].unshift({key:'',text: gettext('All')})

        if scope.search.year
          scope.months = _yearMonthObj[scope.search.year]
        return

      scope.changeYear = (_year)->
        scope.search.year = _year
        scope.search.month = _yearMonthObj[_year][0]
        scope.months = _yearMonthObj[_year]
        scope.searchCallBack({result:scope.search})

      scope.changeMonth = (_month)->
        scope.search.month = _month
        scope.searchCallBack({result:scope.search})

      scope.$watch('minDate',(val)->
        minDate = if not val or val is '' then '2016-09' else val
        date = minDate?.split('-')
        minYear = parseInt date[0]
        minMonth = parseInt date[1]
        _defaultSearch = if !!scope.defaultSearch then scope.defaultSearch else currYear + '-' + currMonth
        scope.search = {
          year: +_defaultSearch.split('-')[0]
          month:{
            key: _defaultSearch.split('-')[1]
            text:getMonthText(_defaultSearch.split('-')[1])
          }
        }
        scope.years = []
        initSearchDate()
      )

      return
  }
]
