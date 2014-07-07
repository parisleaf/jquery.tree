factory = ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  PLUGIN_NAME = 'tree'

  defaults =
    content:               '.content'
    prepend:               true
    listContainer:         null
    filter:                ':header'

  # Plugin class
  class Plugin
    constructor: (@el, options) ->
      plugin = this

      # Extend default settings
      @settings = $.extend {}, defaults, options

      @$content = $(@el)

      if @settings.listContainer?
        @$listContainer = $(@settings.listContainer)

      @$headers = @$content.find('*').filter(@settings.filter)

      @$list = @listify(@$headers)


      if @$listContainer?
        @$listContainer.append(@$list)
      else if @settings.prepend
        @$content.prepend(@$list)

      # The right sidebar list is now created
      # Need to set first child as active
      $('li:first').addClass('active')
      this.isOnScreen
      $(window).scroll =>
        $.each @$headers, (i, header) -> 
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
            #also add to parent
            $($li.get(i)).parents('li').addClass('active')


    # Recursive function that generates a table of contents list from a collection of nodes
    listify: ($nodes) ->
      plugin = this

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
          $list.find("li").last().append(plugin.listify($between))
          $between = $()

      # Loop through nodes
      $nodes.each ->
        $node = $(this)

        # Check if current node is not a top level header
        if not $node.is("h#{topHeaderLevel}")
          $between = $between.add($node)
        else
          listifyBetween()

          # Construct link
          $link = $('<a/>').html($node.html())

          # Give header an id
          id = $node.attr('id')
          if not id?
            id = plugin.slugify($node.text())

            # Check if id is already on page
            id = plugin.uniqueId(id)

            $node.attr('id', id)

          # Set link href to header id
          $link.attr('href', "##{id}")

          # Construct list item
          $item = $('<li/>').append($link)

          # Attach reference from node to item, and vice versa
          $item.data("plugin_#{PLUGIN_NAME}_header", $node)
          $node.data("plugin_#{PLUGIN_NAME}_item", $item)

          $list.append($item)

      # OBOE
      listifyBetween()

      return $list

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

    uniqueId: (id = 'id') ->
      if $("##{id}").length > 0
        id += 0
        return @uniqueId(id)
      else
        return id

    slugify: (text) ->
      text.toString().toLowerCase()
        .replace(/\s+/g, '-')           # Replace spaces with -
        .replace(/[^\w\-]+/g, '')       # Remove all non-word chars
        .replace(/\-\-+/g, '-')         # Replace multiple - with single -
        .replace(/^-+/, '')             # Trim - from start of text
        .replace(/-+$/, '');            # Trim - from end of text

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[PLUGIN_NAME] = (options) ->
    $(@map( ->
      unless $.data @, "plugin_#{PLUGIN_NAME}"
        plugin = new Plugin @, options
        $.data @, "plugin_#{PLUGIN_NAME}", plugin
        return plugin.$list)
      .get(0)
    )

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
