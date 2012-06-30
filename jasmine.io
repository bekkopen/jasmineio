Matcher := Object clone

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

Matcher message := method(inverted,
	"Expected " .. actual .. if(inverted, " not ", " ") .. expectiation fromCamelCaseToSentence .. " " .. expected
)

Sequence fromCamelCaseToSentence := method(
	output := ""
	self foreach(i, char,
		if(char asCharacter isUppercase, 
			output = output asMutable appendSeq(" ", char asCharacter lowercase),
			output = output asMutable appendSeq(char asCharacter)
		)
	)
	output
)

expect := method(actual,
	wrapper := Object clone
	wrapper actual := actual
    wrapper inverted := false
    
    wrapper not := method(
    	self inverted := true
        self
    )
	
	wrapper forward := method(
		matcher := Matcher clone
		matcher actual := actual
		matcher expected := call message arguments at(0)
		matcher expectiation := call message name
		matcher success := matcher doMessage(call message, actual)		
                if(inverted, matcher success := if(matcher success, false, true))
		if(matcher success == false, Exception raise(matcher message(inverted)))
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

# Runner
files := List clone
runnerArguments := System args rest map(item,
	Directory currentWorkingDirectory asMutable appendSeq("/", item))

Directory with(Directory currentWorkingDirectory) walk(item, 
	if(item name endsWithSeq("_spec.io") and (runnerArguments size == 0 or runnerArguments contains(item path)), 
		files append(item path))
)

files foreach(filename, 
	ex := try(doFile(filename))
	if(ex != nil, 
		writeln("Error loading spec file: " .. filename)
		writeln("Message: " .. ex error .. "\n")
	)
)

Jasmine suites foreach(suite,
	suite run
	suite description println

	suite specs foreach(spec,
		if(spec message isEmpty,
			writeln("  ✓ " .. spec description .. ": passed"),
			writeln("  ϰ " .. spec description .. ": " .. spec message))
	)

	success := suite specs select(spec, spec message isEmpty) size
	failures := suite specs size - success

	writeln()
	writeln("Results: " .. suite specs size .. " specs, " .. failures .. " failures")
	writeln()
)