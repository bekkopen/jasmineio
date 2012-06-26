Spec := Object clone
Spec run := method(
	ex := try(doMessage(test))	
	if(ex == nil, 
		self message := "", 
		self message := ex error)
	yield
)

Suite := Object clone
Suite run := method(
	specs foreach(spec, 
		spec run
		yield
	)
)

Jasmine := Object clone 
Jasmine suites := List clone
Jasmine clone := Jasmine

describe := method(description,
	suite := Suite clone
	specs := List clone

	suite description := description
	suite specs := specs
	
	args := call message arguments
	args removeFirst

	args foreach(arg,

		specDescription := arg arguments at(0) asString asMutable removePrefix("\"") removeSuffix("\"")		

		spec := Spec clone
		spec description := specDescription
		spec test := arg arguments at(1)

		specs append(spec)
	)	

	Jasmine suites append(suite)
	suite
)

equals := method(expected, actual,
	if(expected != actual,
		Exception raise("Expected " .. expected .. ", but was " .. actual)
	)
)

stringEquals := method(expected, actual,
  expected foreach(i, char, 
  	if(expected at(i) asCharacter != actual at(i) asCharacter,
  		Exception raise("Expected " .. expected .. ", but was " .. actual .. ". Strings differ at index " .. i))
  )  
)

files := Directory with(Directory currentWorkingDirectory) files
filenames := files map(file, file name) select(name, name endsWithSeq("_spec.io"))
filenames foreach(filename, doFile(filename))

Jasmine suites foreach(suite,
	suite run
	suite description println

	suite specs foreach(spec,
		if(spec message isEmpty,
			writeln("  ✓ " .. spec description .. " : passed"),
			writeln("  ϰ " .. spec description .. ": " .. spec message))
	)

	success := suite specs select(spec, spec message isEmpty) size
	failures := suite specs size - success

	writeln()
	writeln("Results: " .. suite specs size .. " specs, " .. failures .. " failures")
	writeln()
)