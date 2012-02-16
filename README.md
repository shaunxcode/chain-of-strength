Chain Of Strength

What is this? Essentially I needed a way of serializing js statements to pass to phantom js, meaning the functions can not depend on the ability to refer to any outside variables.

Consider (assuming you have a phantom js page object):

x = 6
y = 7
selector = ".div"

page.evaluate -> $(selector).addClass("#div-#{x}-#{y}")

This will fail as it refers to selector, x, and y. 

Chain allows you to build a call chain in place of this like:

COS = require "chain-of-strength"

x = 6
y = 7
selector = ".div"
page.evaluate COS.func $: selector, addClass: "#div-#{x}-#{y}"

Obviously this is a little more noisy, but definitely nicer than

page.evaluate "function(){ return $('#{selector}').addClass('#div-#{x}-#{y}') }"