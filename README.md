# jQuery.tree

jQuery.tree enables automatic generation of "table of contents" -style lists.

## Installation

Grab `jquery.tree.min.js` from the [GitHub repo](https://github.com/parisleaf/jquery.tree), upload it to a server, and add it to your document's head:

```html
<script src="jquery.tree.min.js"></script>
```

### With Bower

jQuery.tree is available as a [Bower](http://bower.io) package.

```bash
bower install jquery.tree --save
```

## Usage

With no configuration (use sensible defaults):

```javascript
$('.content-area').tree();
```

Or, pass an options object:

```javascript
$('.content-area').tree({
  'listContainer':  '.list-container', // Specify list container
  'prepend':        false // Don't prepend list
});
```

Like [.map](http://api.jquery.com/map/), `.tree` returns the generated list object, and so cannot be chained.

By default, the generated list is appended to the beginning of the target object. You can override this behavior with the `listContainer` option, which can be any valid parameter to the jQuery [constructor](http://api.jquery.com/jquery/). Alternatively, you can set the `prepend` option to false and manipulate the returned list object however you like in your own code.

To further specify which elements should appear in the list, use the `filter` option, which accepts the same parameters as jQuery's [`.filter`](http://api.jquery.com/filter/). For instance, if you only want headers h1 and h2 to appear in your table of contents:

```javascript
$('.content-area').tree({
  'filter':  'h1, h2', // Only go two levels deep
});
```

The default is `:header`, which matches all header elements. A future release will allow the use non-header elements, but for now, only h1 through h6 elements are supported. (Non-headers won't break the plugin -- they just won't generate list items.)

## TODO

- Improve scroll spy
- Improve the docs
- Add support for non-header elements
- Add unit tests

## License

Copyright 2014
[Parisleaf](http://parisleaf.com)

Licensed under the [MIT License](http://opensource.org/licenses/MIT)


