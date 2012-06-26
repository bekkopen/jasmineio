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

// Matchers
expected_str := method(expected, actual, 
	if(expected type == actual type,
		"Expected " .. expected .. ", but was " .. actual,
		"Expected " .. expected .. "(" .. expected type .. "), but was " .. actual .."(" .. actual type .. ")"
	)
	
)

equals := method(expected, actual,
	if(expected != actual,
		Exception raise(expected_str(expected, actual))
	)
)

stringEquals := method(expected, actual,
  expected foreach(i, char, 
  	if(expected at(i) asCharacter != actual at(i) asCharacter,
  		Exception raise(expected_str(expected, actual) .. ". Strings differ at index " .. i))
  )  
)

expect := method(expected, expected)

toEqual := method(actual, 
	if(self != actual,
		Exception raise(expected_str(self, actual)), true # Return true if all well
	)
)

toBeNil := method( 
	if(self != nil,
		Exception raise(expected_str(nil, self)), true # Return true if all well
	)
)


// Runtime

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