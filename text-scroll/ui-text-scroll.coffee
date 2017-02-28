ecamsApp.directive 'uiTextScroll', ['$rootScope','$interval','$timeout',($rootScope,$interval,$timeout) ->
  {
    restrict: 'E',
    templateUrl:'../../views/tmpl/directive-ui-text-scroll-tmpl.html',
    replace:true,
    scope:{
      textData: '@'
      textRemove: '='
      textStartPadding: '@'
    },
    link: (scope, element, attr) ->
      
      centerElement = $(element).find '.text-scroll-center'
      leftElement = $(element).find '.text-scroll-left'
      bodyElement = $(element).find '.text-scroll-body'
      textElement = $(element).find('.scroll-text:eq(0)')
      

      textStartPadding = if attr.textStartPadding then parseInt attr.textStartPadding else 50
      bodyElement.css('paddingLeft',textStartPadding)
      textBodyWidth = bodyElement.width()
      startLeft = bodyElement.offset().left


      scrollWidth = 0
      interval = null
      count = 0
      cloned = false

      startInterval = ()->
        interval = $interval ()->
          textLeft = textElement.offset().left
          textElement.offset({left: textLeft - 1})
          nextElement = $(element).find('.scroll-text:eq(1)')
          nextElement.offset({left: nextElement.offset().left - 1}) if nextElement.length
          # 如果有文字移出
          if textLeft - 1 <= startLeft 
            # count 用于获取移出的宽度
            count++ 
            # 移出的宽度小雨或者等于中间文字显示的宽度 并且没有拷贝过移动文字 
            # 则拷贝一份文字并且设置left为 显示的文字宽度减去剩下的文字宽度和设置的再加上中间隔开的间隙
            if (scrollWidth - count) <= textBodyWidth and !cloned
              cloned = true
              scrollElement = textElement.clone(true)
              scrollElement.offset({left: textBodyWidth - (scrollWidth - count) + 30}).insertAfter(textElement)
          # 文字全部移出则删除掉原始文字节点设置当前滚动的为原始节点
          if count >= scrollWidth
            count = 0
            cloned = false
            textElement.remove()
            nextElement.offset({left: nextElement.offset().left + scrollWidth})
            textElement = nextElement
        ,50

      clearInterval = ()->
        $interval.cancel(interval) if interval

      scope.removeScroll = ()->
        clearInterval()
        $(element).remove()

      scope.stopScroll = ()->
        clearInterval()

      scope.startScroll = ()->
        startInterval()

      refreshDom = ()->
        leftElement = $(element).find '.text-scroll-left'
        bodyElement = $(element).find '.text-scroll-body'
        textElement = $(element).find('.scroll-text:eq(0)')
        nextElement = $(element).find('.scroll-text:eq(1)')
        textBodyWidth = bodyElement.width()
        startLeft = bodyElement.offset().left
        # 目前窗口大小改变之后重新开始滚动
        if nextElement.length
          nextElement.remove()
        count = 0
        cloned = false
        textElement.offset({left: startLeft + textStartPadding})

      # 窗口变化后重新获取dom
      $(window).resize ()->
        refreshDom()

      scope.$on("$destroy",()->
        clearInterval() if interval
      )

      $rootScope.$watch 'currentLan',(lan)->
        if lan
          refreshDom()
          centerElement.css('paddingLeft', leftElement.width() + 5)

      # dom生成之后再设置宽度
      init = ()->
        $timeout ()->
          rightElement = $(element).find '.text-scroll-right'
          centerElement.css({
            'padding-left': leftElement.width() + 5
            'padding-right': rightElement.width() + 5 if !!scope.textRemove
          })
          scrollWidth = textElement.width()
          startInterval()
        ,10

      init()

      return
  }
]
