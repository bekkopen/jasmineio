Suite := Object clone
Suite run := method(
	specs foreach(spec, spec run)
)

Spec := Object clone
Spec run := method(
	ex := try(doMessage(test))
	if(ex == nil, 
		self message := "", 
		self message := ex error)
)

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

suite := describe("jasmine.io", 
	
	it("can check for truth",
		equals(true, true)
	), 

	it("can check for lies",
		equals(true, false)
	),

	it("can check that two strings are the same",
		stringEquals("Jasmine.Io", "Jasmine.Io")
	),

	it("can check that two strings are different",
		stringEquals("Jasmine.Io", "Jasmine.Js")
	),

	it("can determine where two strings differ",
		ex := try(stringEquals("Jasmine.Io", "Jasmine.Js"))
		equals("Expected Jasmine.Io, but was Jasmine.Js. Strings differ at index 8", ex error)
	),

	it("should not execute the tests straight away",
		ex := try(doString("describe(\"true\", IT_FAILS)"))
		equals(nil, ex)		
	)
)

suite run

suite description println
suite specs foreach(spec,
	write("\t" .. spec description .. ": ")
	writeln(spec message)
)

equals("jasmine.io", suite description)
equals("can check for truth", suite specs at(0) description)
equals("can check for lies", suite specs at(1) description)

failingSpec := Spec clone
failingSpec test := method(
	Exception raise("Something went wrong...")
)
failingSpec run
equals("Something went wrong...", failingSpec message)

failingSuite := describe("A failing suite",
	it("True is false",
		equals(true, false)
	)
)
failingSuite run
equals("Expected true, but was false", failingSuite specs at(0) message)
