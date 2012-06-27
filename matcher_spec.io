describe("A custom matcher",
	it("is possible to add a new matcher by adding to the Matcher prototype",
		Matcher toBeLessThan := method(expected,
			actual < expected
		)
		matcher := expect(1) toBeLessThan(2)
		expect(matcher success) toBe(true)
	),

	it("is possible to customize the failure message of a custom Matcher",
		Matcher toBeLessThan := method(expected,			
			actual < expected;			
		)
	)
)

describe("Matcher tests for toEqual",

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

describe("toBeNil Matcher",

	it("should expect nil toBeNil",
		result := expect(nil) toBeNil()
		expect(result success) toBe(true)
	),

	it("should expect 2 not toBeNil",
		ex := try(expect(2) toBeNil())
		expect(ex error) toBe("Expected nil, but was 2")		
	)
)