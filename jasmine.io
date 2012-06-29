Matcher := Object clone

Matcher message := ""

Matcher toEqual := method(expected,
	if(actual == expected, return true)
	self message := "Expected " .. expected .. " (" .. expected type .. "), but was " .. actual .. " (" .. actual type .. ")"
	false
)

Matcher toBe := method(expected,
	if(expected type == Sequence type,
		toBeString(expected),
		toEqual(expected))
)

Matcher toBeString := method(expected,
	if(expected == actual, return true)
	expected foreach(i, char, 
  		if(expected at(i) asCharacter != actual at(i) asCharacter,
  	
  		self message := "Expected " .. expected .. ", but was " .. actual .. ". Strings differ at index " .. i)
  	)  	
  	false
)

Matcher toBeNil := method(
	if(actual == nil, return true)
	self message := "Expected nil, but was " .. actual
	false
)

expect := method(actual,
	wrapper := Object clone
	wrapper actual := actual
	wrapper forward := method(
		matcher := Matcher clone
		matcher actual := actual
		matcher success := matcher doMessage(call message, actual)
		if(matcher success == false, Exception raise(matcher message))
		matcher
	)
	wrapper
)

Spec := Object clone
Spec run := method(
	ex := try(doMessage(test))	
	if(ex == nil, 
		self message := "", 
		self message := ex error)
	self
)

Suite := Object clone
Suite run := method(
	specs foreach(spec, 
		spec run
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

		if(arg name beginsWithSeq("x"), continue, specs append(spec))		
	)	

	Jasmine suites append(suite)
	suite
)

xdescribe := method(nil)

# Runtime
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