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

describe("jasmine.io", 	
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

describe("Spec",
	it("Should be possible to run a spec and detect failure",
		failingSpec := Spec clone
		failingSpec test := method(
			Exception raise("Something went wrong...")
		)
		failingSpec run
		equals("Something went wrong...", failingSpec message)
	),

	it("Should be possible to get description of spec",
		suite := describe("A Suite", it("Spec"))
		equals("Spec", suite specs at(0) description)
	)
)
Jasmine suites at(1) run
equals("", Jasmine suites at(1) specs at(0) message)
equals("", Jasmine suites at(1) specs at(1) message)

describe("Suite", 	
	it("Should be possible to run a suite and detect failure",
		failingSuite := describe("A failing suite",
			it("True is false",
				equals(true, false)
			)
		)
		failingSuite run
		equals("Expected true, but was false", failingSuite specs at(0) message)
	),

	it("Should be possible to get the description of the suite",
		suite := describe("My Description")
		equals("My Description", suite description)
	)
)
Jasmine suites at(3) run
equals("", Jasmine suites at(3) specs at(0) message)
equals("", Jasmine suites at(3) specs at(1) message)