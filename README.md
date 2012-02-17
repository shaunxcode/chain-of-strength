Chain Of Strength
=================
*What is this?* Essentially I needed a way of serializing js statements to pass to phantom js, meaning the functions can not depend on the ability to refer to any outside variables.

Consider (assuming you have a phantom js page object):

```coffeescript
x = 6

y = 7

selector = ".div"

page.evaluate -> $(selector).addClass("#div-#{x}-#{y}")
```
This will fail as it refers to selector, x, and y. 

Chain allows you to build a function returning a call chain:

```coffeescript
COS = require "chain-of-strength"

x = 6
y = 7
selector = ".div"

page.evaluate COS.func $: selector, addClass: "#div-#{x}-#{y}"

```

Obviously this is a little more noisy, but definitely nicer than

```coffeescript
page.evaluate "function(){ return $('#{selector}').addClass('#div-#{x}-#{y}') }"
```

You can also just get a raw method chain w/o a function wrapper by calling buildChain 

```coffeescript
COS.buildChain ['a', b: [1,2]]

#yields

"a.b(1,2)"
```

There are times when you may want to have a nested callback e.g. to a map/filter method

```coffeescript
COS.func $: selector, map: func: ["$(this)", css: "display"]

#yields

'function(){return $(".div").map(function(){return $(this).css("display")})}'
```