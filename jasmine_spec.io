describe("Suites", 	
	it("Should be possible to run a suite and detect failure",
		failingSuite := describe("A failing suite",
			it("True is false",
				expect(true) toBe(false)
			)
		)
		failingSuite run
		message := failingSuite specs at(0) message
		Jasmine suites remove(failingSuite)
		expect(message) toBe("Expected false (false), but was true (true)")
	),

	it("Should be possible to get the description of the suite",
		suite := describe("My Description")
		description := suite description
		Jasmine suites remove(suite)
		expect(description) toBe("My Description")		
	),

	it("Should not execute the tests straight away",
		suite := doString("describe(\"true\", IT_FAILS)")
		Jasmine suites remove(suite)
	)
)

describe("Specs",
	it("Should be possible to run a spec and detect failure",
		failingSpec := Spec clone
		failingSpec test := method(
			Exception raise("Something went wrong...")
		)
		failingSpec run
		expect(failingSpec message) toBe("Something went wrong...")
	),

	it("Should be possible to get description of spec",
		aSuite := describe("A Suite", it("Spec"))
		description := aSuite specs(0) at(0) description
		Jasmine suites remove(aSuite)
		expect(description) toBe("Spec")
	)
)

describe("Disabling of suites and specs",
	it("Should be possible to disable a suite by using xdescribe",
		noSuite := xdescribe("A disabled")
  		expect(noSuite) toBeNil()
	),

	it("Should be possible to disable a spec by using xit",
		suiteWithDisabledSpec := describe("A suite",
			xit("A disabled spec",
				expect(true) toBe(false)
			)
		)
		numberOfSpecs := suiteWithDisabledSpec specs size
		Jasmine suites remove(suiteWithDisabledSpec)
		expect(numberOfSpecs) toBe(0)
	)
)