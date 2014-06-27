(function() {
  (function($, window, document) {
    var Plugin, defaults, pluginName;
    pluginName = "movingScroll";
    defaults = {
      content: ".content",
      list: ".list"
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this._name = pluginName;
        this.settings = $.extend({}, defaults, options);
        this._defaults = defaults;
        this.init();
      }

      Plugin.prototype.isOnScreen = function() {
        var win;
        win = $(window);
        return console.log(win.scrollTop());
      };

      Plugin.prototype.init = function() {
        var $content, $headers, $list_container, $top_list, header_array, startList;
        console.log("Plugin initialization");
        $content = $(this.settings.content);
        $list_container = $(this.settings.list);
        $headers = $content.children(':header');
        header_array = [];
        $headers.each(function() {
          return header_array.push($(this).text());
        });
        $top_list = $('<ul/>');
        $list_container.append($top_list);
        startList = function($headers, $top, last_level) {
          var $current, $list, current_level, i, item, _results;
          i = 0;
          _results = [];
          while ($headers.length !== 0) {
            console.log('last_level: ' + last_level);
            $current = $headers.get(0);
            current_level = parseInt($headers.get(0).nodeName.substring(1));
            console.log('current_level: ' + current_level);
            if (current_level === last_level) {
              item = "<li>" + $headers.eq(0).text() + "</li>";
              $top.append(item);
              $headers = $headers.slice(1);
              _results.push(i = i + 1);
            } else if (current_level > last_level) {
              $list = $('<ul/>');
              $top.append($list);
              item = "<li>" + $headers.eq(0).text() + "</li>";
              $list.append(item);
              $headers = $headers.slice(1);
              i = 0;
              _results.push(current_level = last_level);
            } else if (current_level < last_level) {
              console.log("About to start recursion, current_level = " + current_level);
              _results.push(startList($headers, $top, current_level));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
        startList($headers, $top_list, 1);
        $('li:first').addClass('active');
        this.isOnScreen;
        return $(window).scroll(function() {
          return $.each($headers, function(i, header) {
            var $current, $list, difference;
            $current = $(header);
            difference = $current.offset().top - $(window).scrollTop();
            if (difference < 100) {
              $('.active').removeClass('active');
              $current.addClass('active');
              $list = $('li');
              return $($list.get(i)).addClass('active');
            }
          });
        });
      };

      return Plugin;

    })();
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

//# sourceMappingURL=jquery.boilerplate.js.map
