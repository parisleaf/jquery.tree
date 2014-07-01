# jQuery.tree

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

Apply the plugin to a jQuery object consisting of a content and list container class.  The `.content` class should have the headers `<h1>` through `<h6>` that you would like to generate a list from.  The `.list` class will be the container that you want your list injected into.  

With no configuration (use sensible defaults):

```javascript
$('.content-area').tree();
```

Or, pass an options object:

```javascript
$('.content-area').tree({
  'content':     '.content-container',
  'list':        '.list-container'
});
```

## TODO

- Improve the docs
- Make the list clickable links that bring you to that portion of the content
- Hide sub lists unless in focus

## License

Copyright 2013
[Parisleaf](http://parisleaf.com)

Licensed under the [MIT License](http://opensource.org/licenses/MIT)


