# directive

uiLimitLength 用于限制文本框中英文输入字符 中文占2个字符
<pre>input.form-control(type='text',required,name="viewName",ng-model="view.view_name", ui-limit-length="30" placeholder="{{'Please enter view name'|translate}}")</pre>




uiTextScroll 用于头部文字滚动 左右滚动。。初始有50的间距 窗口resize后会重新开始滚动
<pre>ui-text-scroll(text-data="{{notice}}" text-remove="true" ng-if="!!showNotice")</pre>



uiSearchDateSelect 用于年月搜索。可以设置最小值。搜索返回一个对象{year:xx,month:xx}
<pre>ui-search-date-select(min-date="{{minDate}}" search-on-default="true" search-call-back="searchCostByMonth(result)")</pre>



uiSearchBox 用于头部条件搜索。返回一个对象
<pre>div.clearfix.search-box-container
  ui-search-box.pull-right(search-key="searchInstanceList" search-call-back="searchInstanceCallBack(result)" disable-filter="server['instance'].disableFilterByLimit") 
div.pull-left.search-left
  div.search-tabs.pull-left.clearfix(ng-repeat="tab in server['instance'].searchTabs")
    div.pull-left.search-tab-item
      span.pull-left {{tab.key.text | translate}}:
      span.filter-text(title="{{(tab.value.text || tab.value) | translate}}") {{(tab.value.text || tab.value) | translate}}
    div.pull-left.search-tab-remove
      i.fa.fa-times(aria-hidden="true" ng-click="removeSearchTab('instance',$index)")
button.btn.btn-sm.btn-success.search-btn(type='button' ng-click="search('instance')" </pre>
<pre>searchInstanceList = [
  {
    key: 'key'
    text: displaytext
    type: 'list'
    values: [{
      key: key
      text: text
    }]
  }
  {
    key: 'key'
    text: displaytext
    type: 'text'
  }
]</pre>

//controller 处理方法。同一个key只能出现在filter里一次。
<pre>searchCallBack = (resourceType,data)->
  searchList = $scope.server[resourceType].searchTabs
  add_flag = searchList.find (n)-> 
    return n.key.key is data.key.key
  if !add_flag
    searchList.push data
  else
    add_flag.value = data.value
  if searchList.length >= $scope.limitFilter
     $scope.server[resourceType].disableFilterByLimit = true

$scope.removeSearchTab = (resourceType,index)->
  $scope.server[resourceType].searchTabs.splice(index,1)
  $scope.server[resourceType].disableFilterByLimit = false

$scope.search = (searchType)->
  filterList = []
  $scope.server[searchType].searchFilter = []
  angular.forEach $scope.server[searchType].searchTabs,(item)->
   filterList.push {
    'name': item.key.key,
    'op': if item.value.key then 'eq' else 'like',
    'val': if item.value.key then item.value.key else '%'+item.value+'%'
   }
  if filterList.length > 0
    $scope.server[searchType].searchFilter.push {
      'and': filterList
    }

  $scope.currentPage = 1
  switch searchType
    when 'instance' then getInstancesList()
    when 'disk' then getDisksList()
    when 'snapshot' then getSnapshotsList()
  return
  </pre>
  
  
  
  <br>
  
  
  
  
  请在directive 里 自行修改template路径
