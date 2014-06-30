# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "movingScroll"
  defaults =
    content: ".content"
    list: ".list"

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      @_name = pluginName
            # future instances of the plugin
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @init()

    isOnScreen: ->
      win = $(window)
      console.log win.scrollTop()
     
    init: ->
      # Place initialization logic here
      # You already have access to the DOM element and the options via the instance,
      # e.g., @element and @settings
      console.log "Plugin initialization"
      $content = $(@settings.content)  
      $list_container = $(@settings.list)
      
      #First take the H1 header tags in content and make a ul list in the list nav
      $headers = $content.children(':header')
      header_array = []
      $headers.each ->
        header_array.push($(this).text())

      # With the headers, create the UL
      $top_list = $('<ul/>')
      $list_container.append($top_list)
      #for header in header_array
      #  $top_list.append("<li>" + header + "</li>")
      
      # startList = ($headers, $top) ->
      #   #implicit returns on the last 
      #   #headers are what you have left
      #   #top is the topmost list
      #   $headers = $headers.clone() 
      #   #first append new list
      #   $inner = $('<ul/>')
      #   $top.append($inner)
      #   $inner.append("<li>" + $headers.eq(0).text() + "</li>")
      #   current_level = parseInt $headers.get(0).nodeName.substring(1)
      #   counter = 0
      #   first_length = $headers.length
      #   while counter < first_length
      #     console.log "removing " + $headers.eq(0).text()
      #     $headers = $headers.slice(1)
      #     if $headers.length > 0
      #       h_level = parseInt $headers.get(0).nodeName.substring(1)
      #       console.log "h_level: " + h_level
      #       console.log "current_level " + current_level
         

      #       if(h_level > current_level)
      #         # recursive call
      #         console.log "starting recursive call"
      #         startList $headers, $inner
      #       else if(h_level < current_level) 
      #         $headers = $headers.slice(1)
      #         #startList $headers, $inner
      #         break

      #       else
              
      #         $inner.append("<li>" + $headers.eq(0).text() + "</li>")
      #         counter = counter + 1
      #     else
      #       break
      #   #$.each $headers, (i, header) ->
      
      startList = ($headers, $top, last_level) ->
        
        for i in [0..$headers.length-1]
        #$.each $headers, (i, header) ->
          console.log 'last_level: ' + last_level
          $current = $headers.get(i)
          current_level = parseInt $headers.get(i).nodeName.substring(1)
          console.log 'current_level: ' + current_level
          if current_level == last_level 
            console.log("[equals] " + $headers.eq(i).text())
            item = "<li>" + $headers.eq(i).text() + "</li>"
            $top.append(item)
            #$headers = $headers.slice(1)
          else if current_level > last_level
            $list = $('<ul/>')
            $top.append($list)
            item = "<li>" + $headers.eq(i).text() + "</li>"
            $list.append(item)
            $top = $list
            #$headers = $headers.slice(1)
            last_level = current_level
            #startList $headers, $list, current_level
          else if current_level < last_level
            console.log("[current < last]" + $headers.eq(i).text())
            #append and delete that last item
            #while current_level < last_level
            #  $top = $top.parent()
            #  last_level = last_level - 1
            step_level = last_level
            inner = i-1
            while current_level != step_level
              step_level = parseInt $headers.get(inner).nodeName.substring(1)
              if step_level != last_level
                $top = $top.parent()
              console.log "current_level after loop: " + current_level
              inner = inner - 1
              console.log "last_level after loop: " + last_level

            item = "<li>" + $headers.eq(i).text() + "</li>"
            $top.append(item)
            last_level = parseInt $headers.get(i).nodeName.substring(1)
             #$headers = $headers.slice(1)
             # startList $headers, $top, current_level
            #break
         
      startList $headers, $top_list, 1
      #$.each $headers, (i, header) ->
        
    

      # The right sidebar list is now created
      # Need to set first child as active
      $('li:first').addClass('active')
      this.isOnScreen
      $(window).scroll ->
        $.each $headers, (i, header) -> 
          #console.log $header
          $current = $(header)
          difference = $current.offset().top - $(window).scrollTop()
          if difference < 100 
            #console.log $current
            $('.active').removeClass('active')
            $current.addClass('active')
            #now find the current list item to activate
            $list = $('li')
            $($list.get(i)).addClass('active') 
  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Plugin @, options
