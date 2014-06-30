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

      Plugin.prototype.headerDepth = function(el) {
        return parseInt(el.nodeName.slice(-1));
      };

      Plugin.prototype.topHeaderLevel = function($content) {
        var num, _i;
        for (num = _i = 1; _i <= 6; num = ++_i) {
          if ($content.find("h" + num).length > 0) {
            return num;
          }
        }
        return null;
      };

      Plugin.prototype.init = function() {
        var $allContent, $headers, $list, $listContainer, listify;
        $allContent = $(this.settings.content);
        $listContainer = $(this.settings.list);
        $headers = $allContent.find(':header');
        listify = (function(_this) {
          return function($content) {
            var $firstChild, $list, $preamble, $topLevelHeaders, topHeaderLevel;
            topHeaderLevel = _this.topHeaderLevel($content);
            if (topHeaderLevel == null) {
              return null;
            }
            $list = $("<ul/>");
            $topLevelHeaders = $content.find("h" + topHeaderLevel);
            $firstChild = $content.find(":first-child");
            if (!$firstChild.is($topLevelHeaders)) {
              $preamble = $firstChild.nextUntil($topLevelHeaders).addBack().clone().wrapAll("<div/>").parent();
              $preamble = $preamble.wrapAll("<div/>");
              $list.append(listify($preamble));
            }
            $topLevelHeaders.each(function() {
              var $between, $header, $item, $link;
              $header = $(this);
              $link = $('<a/>').html($header.html());
              $item = $('<li/>').append($link);
              $list.append($item);
              $between = $header.nextUntil($topLevelHeaders).clone().wrapAll("<div/>").parent();
              return $list.append(listify($between));
            });
            return $list;
          };
        })(this);
        $list = listify($allContent);
        $listContainer.append($list);
        $('li:first').addClass('active');
        this.isOnScreen;
        return $(window).scroll(function() {
          return $.each($headers, function(i, header) {
            var $current, $li, difference;
            $current = $(header);
            difference = $current.offset().top - $(window).scrollTop();
            if (difference < 100) {
              $('.active').removeClass('active');
              $current.addClass('active');
              $li = $('li');
              return $($li.get(i)).addClass('active');
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
