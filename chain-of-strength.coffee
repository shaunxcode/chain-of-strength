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

buildArgList = (args) ->
	argList = []
	if not Type.is args, "Array" then args = [args]
	argList.push(if (Type.is(arg, "Object") and arg.func?) then "function(){return #{exports.buildChain arg.func}}" else JSON.stringify arg) for arg in args
	argList.join()
		
exports.buildChain = (cmd) ->
	chain = cmd.shift()
	
	#this allows for [$: selector, method: arg] type expressions
	if Type.is chain, "Object"
		chainStart = false
		subArgs = {}
		for k, v of chain
			if not chainStart
				chainStart = "#{k}(#{buildArgList v})"
			else
				subArgs[k] = v
		chain = chainStart
		cmd.unshift subArgs

	for part in cmd
		if Type.is part, "Object"
			for method, args of part
				chain += ".#{method}(#{buildArgList args})"
		else if Type.is part, "String"
			chain += ".#{part}"
		else 
			throw new Error "cmd must be made of property names or object key/val pairs"

	chain

exports.func = (args...) ->
	"function(){#{exports.buildChain args}}"