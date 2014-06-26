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
      $header_list = $('<ul/>');
      $list_container.append($header_list);
      for header in header_array
        $header_list.append("<li>" + header + "</li>")

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
