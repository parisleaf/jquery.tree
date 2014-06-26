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
        var $content, $header_list, $headers, $list_container, header, header_array, _i, _len;
        console.log("Plugin initialization");
        $content = $(this.settings.content);
        $list_container = $(this.settings.list);
        $headers = $content.children(':header');
        header_array = [];
        $headers.each(function() {
          return header_array.push($(this).text());
        });
        $header_list = $('<ul/>');
        $list_container.append($header_list);
        for (_i = 0, _len = header_array.length; _i < _len; _i++) {
          header = header_array[_i];
          $header_list.append("<li>" + header + "</li>");
        }
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
