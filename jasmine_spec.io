describe("jasmine.io equals", 	
	it("can check for truth",
		equals(true, true)
	), 

	it("can check for lies",
		ex := try(equals(true, false))
		equals("Expected true, but was false", ex error)
	)
)

describe("jasmine.io stringEquals",
	it("can check that two strings are the same",
		stringEquals("Jasmine.Io", "Jasmine.Io")
	),

	it("can determine where two strings differ",
		ex := try(stringEquals("Jasmine.Io", "Jasmine.Js"))
		equals("Expected Jasmine.Io, but was Jasmine.Js. Strings differ at index 8", ex error)
	)	
)

describe("jasmine.io Spec",
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
		Jasmine suites remove(suite)
	)
)

describe("jasmine.io Suite", 	
	it("Should be possible to run a suite and detect failure",
		failingSuite := describe("A failing suite",
			it("True is false",
				equals(true, false)
			)
		)
		failingSuite run
		equals("Expected true, but was false", failingSuite specs at(0) message)
		Jasmine suites remove(failingSuite)
	),

	it("Should be possible to get the description of the suite",
		suite := describe("My Description")
		equals("My Description", suite description)
		Jasmine suites remove(suite)
	),

	it("Should not execute the tests straight away",
		suite := doString("describe(\"true\", IT_FAILS)")
		Jasmine suites remove(suite)
	)	
)