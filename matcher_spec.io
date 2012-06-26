describe("Matcher tests for toEqual",

	it("should expect true toEqual true to be true",
		equals(true, expect(true) toEqual(true))
	),

	it("should expect false toEqual false to be true",
		equals(true, expect(false) toEqual(false))
	),

	it("should expect 2 toEqual 2 to be true",
		equals(true, expect(2) toEqual(2))
	),

	it("should expect 'string' toEqual 'string' to be true",
		equals(true, expect("string") toEqual("string"))
	),

	it("should expect false toEqual true to be false",
		ex := try(expect(false) toEqual(true))
		equals("Expected false(false), but was true(true)", ex error)
	),

	it("should expect 'string' not toEqual 'string2'",
		ex := try(expect("string") toEqual("string2"))
		equals("Expected string, but was string2", ex error)
	),

	it("should expect '2' not toEqual 2 (number)",
		ex := try(expect("2") toEqual(2))
		equals("Expected 2(Sequence), but was 2(Number)", ex error)
	),

	it("should not care about the sequence of arguments",
		ex := try(expect(2) toEqual("2"))
		equals("Expected 2(Number), but was 2(Sequence)", ex error)
	),

	it("should expect 2 not toEqual nil",
		ex := try(expect(2) toEqual(nil))
		equals("Expected 2(Number), but was nil(nil)", ex error)
	)

)

describe("Matcher tests for toBeNil",

	it("should expect nil toBeNil",
		equals(true, expect(nil) toBeNil)
	),

	it("should expect 2 not toBeNil",
		ex := try(expect(2) toBeNil)
		equals("Expected nil(nil), but was 2(Number)", ex error)
	)

)