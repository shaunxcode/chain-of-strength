Type = 
	getType: do ->
		classToType = {}
		for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
			classToType["[object " + name + "]"] = name

		(obj) ->
			strType = Object::toString.call(obj)
			classToType[strType] or "Object"

	is: (obj, typeName) ->
		Type.getType(obj) is typeName

exports.buildChain = (cmd) ->
	chain = cmd.shift()

	for part in cmd
		if Type.is part, "Object"
			for method, args of part
				argList = []
				if not Type.is args, "Array" then args = [args]
				argList.push(JSON.stringify arg) for arg in args
				chain += ".#{method}(#{argList.join()})"
		else if Type.is part, "String"
			chain += ".#{part}"
		else 
			throw new Error "cmd must be made of property names or object key/val pairs"

	chain