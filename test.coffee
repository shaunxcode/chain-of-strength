COS = require "./chain-of-strength"

failures = false
equals = (desc, input, expected) ->
	if input isnt expected
		failures = true
		console.log "\nFailed #{desc}:\nExpected:"
		console.log expected
		console.log "Got:"
		console.log input
		
assert = (desc, input, expected) ->
	equals desc, COS.buildChain(input), expected

assert "simple selector", 
	["selector", a: 1, b: 2, "length"],
	"selector.a(1).b(2).length"

assert "multiple args",
	["x", a: [1, 2, [3, 4]]],
	"x.a(1,2,[3,4])"

assert "pass a single array",
	["x", a: [[1,2,3]]],
	"x.a([1,2,3])"

assert "no args",
	["xabra", a: [], b:[1,2]],
	"xabra.a().b(1,2)"
	
assert "functions",
	["peter", map: func: ["a", b: [1, 2]]],
	"peter.map(function(){return a.b(1,2)})"

selector = ".div-a"
x = 3
y = "apple"

assert "func wrapper", 
	[$: [selector, "parent"], addClass: "#div-2#{x}-#{y}", twice: 3, 'length', joinBy: "apple"], 
	"$(\"#{selector}\",\"parent\").addClass(\"#div-23-apple\").twice(3).length.joinBy(\"apple\")"

equals "basic COS func",
	COS.func $: "a", with: "b", and: "c", "length", cat: "Fish"
	'function(){return $("a").with("b").and("c").length.cat("Fish")}'

equals "COS func with array arg",
	COS.func [{$: ".certificatesTable"}, map: func: ["$(this)", css: "display"]]
	'function(){return $(".certificatesTable").map(function(){return $(this).css("display")})}'

console.log if failures then "Not all tests passed. See above" else "All passed!"