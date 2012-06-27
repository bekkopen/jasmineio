describe("jasmine.io stringEquals",
	it("can check that two strings are the same",
		expect("Jasmine.Io") toBe("Jasmine.Io")
	),

	it("can determine where two strings differ",
		ex := try(expect("Jasmine.Io") toBe("Jasmine.Js"))	
		expect(ex error) toEqual("Expected Jasmine.Js, but was Jasmine.Io. Strings differ at index 9")
	)	
)

describe("jasmine.io Spec",
	it("Should be possible to run a spec and detect failure",
		failingSpec := Spec clone
		failingSpec test := method(
			Exception raise("Something went wrong...")
		)
		failingSpec run
		expect(failingSpec message) toBe("Something went wrong...")
	),

	it("Should be possible to get description of spec",
		suite := describe("A Suite", it("Spec"))
		expect(suite specs(0) at(0) description) toBe("Spec")
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
		expect(failingSuite specs at(0) message) toBe("Expected true(true), but was false(false)")
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