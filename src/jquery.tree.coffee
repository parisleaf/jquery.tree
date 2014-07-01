factory = ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "tree"
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
     
    headerDepth: (el) ->
      return parseInt(el.nodeName.slice(-1))

    topHeaderLevel: ($content) ->
      for num in [1..6]
        if $content.find("h#{num}").length > 0
          return num

      return null

    init: ->
      # Place initialization logic here

      ## Andrew


      $allContent = $(@settings.content)
      $listContainer = $(@settings.list)

      $headers = $allContent.find(':header')

      # Returns list of headers found in $content
      listify = ($content) =>

        # Get top level header found in content
        topHeaderLevel = @topHeaderLevel($content)

        # Exit if content has no headers
        if not topHeaderLevel? then return null

        # Create list
        $list = $("<ul/>")

        # Get all the top level headers
        $topLevelHeaders = $content.find("h#{topHeaderLevel}")

        # If first element in content is not a top-level header,
        # recursively call listify
        $firstChild = $content.find(":first-child")
        if not $firstChild.is($topLevelHeaders)
          $preamble = $firstChild.nextUntil($topLevelHeaders)
            .addBack()
            .clone()
            .wrapAll("<div/>")
            .parent()

          $preamble = $preamble.wrapAll("<div/>")
          $list.append(listify($preamble))

        # Loop through each top level header
        $topLevelHeaders.each ->
          $header = $(this)

          # Construct list item and append to list
          $link = $('<a/>').html($header.html())
          $item = $('<li/>').append($link)
          $list.append($item)

          # Wrap content until next header and recursively call listify
          $between = $header
            .nextUntil($topLevelHeaders)
            .clone()
            .wrapAll("<div/>")
            .parent()

          $list.append(listify($between))

        return $list

      $list = listify($allContent)

      $listContainer.append($list)

      ## end Andrew
        
    

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
            $li = $('li')
            $($li.get(i)).addClass('active') 


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Plugin @, options

# Register module
do (factory, window, document) -> 
  if typeof define is 'function' and define.amd
    # AMD. Register as an anonymous module.
    define(['jquery'], factory)
  else if typeof exports is 'object'
    # Node/CommonJS
    factory(require('jquery'), window, document)
  else
    # Browser globals
    factory(jQuery, window, document)