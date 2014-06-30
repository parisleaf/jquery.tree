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
          var $current, $list, current_level, i, inner, item, step_level, _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = $headers.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            console.log('last_level: ' + last_level);
            $current = $headers.get(i);
            current_level = parseInt($headers.get(i).nodeName.substring(1));
            console.log('current_level: ' + current_level);
            if (current_level === last_level) {
              console.log("[equals] " + $headers.eq(i).text());
              item = "<li>" + $headers.eq(i).text() + "</li>";
              _results.push($top.append(item));
            } else if (current_level > last_level) {
              $list = $('<ul/>');
              $top.append($list);
              item = "<li>" + $headers.eq(i).text() + "</li>";
              $list.append(item);
              $top = $list;
              _results.push(last_level = current_level);
            } else if (current_level < last_level) {
              console.log("[current < last]" + $headers.eq(i).text());
              step_level = last_level;
              inner = i - 1;
              while (current_level !== step_level) {
                step_level = parseInt($headers.get(inner).nodeName.substring(1));
                if (step_level !== last_level) {
                  $top = $top.parent();
                }
                console.log("current_level after loop: " + current_level);
                inner = inner - 1;
                console.log("last_level after loop: " + last_level);
              }
              item = "<li>" + $headers.eq(i).text() + "</li>";
              $top.append(item);
              _results.push(last_level = parseInt($headers.get(i).nodeName.substring(1)));
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
