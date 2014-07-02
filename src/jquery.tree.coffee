factory = ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  PLUGIN_NAME = 'tree'

  defaults =
    content: '.content'
    list:    '.list'

  # Plugin class
  class Plugin
    constructor: (@element, options) ->
      @_name = PLUGIN_NAME
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      
      $content = $(@settings.content)

      # Descendents of content
      $contentNodes = $content.find('*')

      $listContainer = $(@settings.list)

      $headers = $content.find(':header')

      # Recursive function that generates a table of contents list from a collection of nodes
      listify = ($nodes) =>

        # Get top header level found in collection
        topHeaderLevel = @topHeaderLevel($nodes)

        # Exit if none of the nodes are headers
        if not topHeaderLevel? then return null

        # Create list
        $list = $("<ul/>")

        # Initialize empty jQuery object to contain nodes that fall between top-level headers
        $between = $()

        # Function to recursively listify and reset $between
        listifyBetween = ->
          if $between.length > 0
            $list.find("li").last().append(listify($between))
            $between = $()

        # Loop through nodes
        $nodes.each ->
          $node = $(this)

          # Check if current node is not a top level header
          if not $node.is("h#{topHeaderLevel}")
            $between = $between.add($node)
          else
            listifyBetween()

            # Construct list item
            $link = $('<a/>').html($node.html())
            $item = $('<li/>').append($link)

            # Attach reference from node to item, and vice versa
            $item.data("plugin_#{PLUGIN_NAME}_header", $node)
            $node.data("plugin_#{PLUGIN_NAME}_item", $item)

            $list.append($item)

        # OBOE
        listifyBetween()

        return $list

      $list = listify($contentNodes)

      $listContainer.append($list)        
      

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

    isOnScreen: ->
      win = $(window)
      console.log win.scrollTop()
     
    headerDepth: (el) ->
      return parseInt(el.nodeName.slice(-1))

    topHeaderLevel: ($nodes) ->
      for num in [1..6]
        if $nodes.is("h#{num}")
          return num

      return null 

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[PLUGIN_NAME] = (options) ->
    @each ->
      unless $.data @, "plugin_#{PLUGIN_NAME}"
        $.data @, "plugin_#{PLUGIN_NAME}", new Plugin @, options

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