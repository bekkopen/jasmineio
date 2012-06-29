describe("A custom matcher",
	it("is possible to add a new matcher by adding to the Matcher prototype",
		matcher := expect(1) toBeLessThan(2)
		expect(matcher success) toBe(true)
	),	

	it("should generate a default error message for custom matchers",
		ex := try(expect(2) toBeLessThan(1))
		expect(ex error) toBe("Expected 2 toBeLessThan 1")
	)
)

xdescribe("Matcher tests for toEqual",
	it("should expect true toEqual true to be true",
		matcher := expect(true) toEqual(true)
		expect(matcher success) toBe(true)
	),

	it("should expect false toEqual false to be true",
		matcher := expect(false) toEqual(false)
		expect(matcher success) toBe(true)
	),

	it("should expect 2 toEqual 2 to be true",
		matcher := expect(2) toEqual(2)
		expect(matcher success) toBe(true)
	),

	it("should expect 'string' toEqual 'string' to be true",
		matcher := expect("string") toEqual("string")
		expect(matcher success) toBe(true)
	),

	it("should expect false toEqual true to be false",
		ex := try(expect(false) toEqual(true))
		expect(ex error) toBe("Expected true (true), but was false (false)")
	),

	it("should expect 'string' not toEqual 'string2'",
		ex := try(expect("string") toEqual("string2"))
		expect(ex error) toBe("Expected string2 (Sequence), but was string (Sequence)")
	),

	it("should expect '2' not toEqual 2 (number)",
		ex := try(expect("2") toEqual(2))
		expect(ex error) toBe("Expected 2 (Number), but was 2 (Sequence)")
	)
)

xdescribe("toBeNil Matcher",

	it("should expect nil toBeNil",
		result := expect(nil) toBeNil()
		expect(result success) toBe(true)
	),

	it("should expect 2 not toBeNil",
		ex := try(expect(2) toBeNil())
		expect(ex error) toBe("Expected nil, but was 2")		
	)
)

xdescribe("toBe Matcher for strings",
	it("can check that two strings are the same",
		expect("Jasmine.Io") toBe("Jasmine.Io")
	),

	it("can determine where two strings differ",
		ex := try(expect("Jasmine.Io") toBe("Jasmine.Js"))	
		expect(ex error) toEqual("Expected Jasmine.Js, but was Jasmine.Io. Strings differ at index 9")
	)	
)

describe("Not matcher",

        it("inverts expectation",
                result := expect(1) not toEqual(2)
                expect(result success) toBe(true)
        ),

        it("inverts default error messages",
                ex := try(expect(1) not toBeLessThan(2))
                expect(ex error) toEqual("Expected 1 not toBeLessThan 2")
        )
)
