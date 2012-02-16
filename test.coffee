COS = require "./chain-of-strength"

failures = false
assert = (desc, input, expected) ->
	if (got = COS.buildChain input) isnt expected
		console.log "Failed #{desc}: expected:"
		console.log expected
		console.log "Got:"
		console.log got
		failures = true

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

console.log if failures then "Not all tests passed. See above" else "All passed!"