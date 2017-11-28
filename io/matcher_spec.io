Matcher toBeLessThan := method(expected, actual < expected)

Matcher toBeGreaterThan := method(expected,
	if(actual > expected, return false)
	self message := actual .. " is not greater than " .. expected
	false
)

describe("Custom matchers",
	it("is possible to add a new matcher by adding to the Matcher prototype",
		matcher := expect(1) toBeLessThan(2)
		expect(matcher success) toBe(true)
	),	

	it("should generate a default error message for custom matchers",
		ex := try(expect(2) toBeLessThan(1))
		expect(ex error) toEqual("Expected 2 to be less than 1")
	),

	it("should use custom error message if set by custom matcher",
		ex := try(expect(1) toBeGreaterThan(2))
		expect(ex error) toBe("1 is not greater than 2")
	)
)

MyException := Exception clone
YourException := Exception clone

describe("toThrow matcher",
	it("should be possible to test that an exception is thrown",
		matcher := expect(block(Exception raise("Something crashed"))) toThrow()
		expect(matcher success) toBe(true)
	),

	it("should fail if an exception is not thrown",
		ex := try(expect(block(1)) toThrow())
		expect(ex error) toBe("Expected an exception to be thrown, but no exception was thrown.")
	),

	it("should be possible to test that an exception with a certain message is thrown",
		matcher := expect(block(Exception raise("Something crashed"))) toThrow("Something crashed")
		expect(matcher success) toBe(true)
	),

	it("should fail if an exception is not thrown and should show the message being looked for",
		ex := try(expect(block(1)) toThrow("Something crashed"))
		expect(ex error) toBe("Expected an exception to be thrown with message 'Something crashed', but no exception was thrown.")
	),

	it("should fail if an exception is not thrown with that exact message",
		ex := try(expect(block(Exception raise("Oops"))) toThrow("Something crashed"))
		expect(ex error) toBe("Expected an exception to be thrown with message 'Something crashed', but an exception with message 'Oops' was thrown.")
	),

	it("should fail if an exception is not thrown when looking for a specific type",
		ex := try(expect(block(1)) toThrow(MyException))
		expect(ex error) toBe("Expected an exception to be thrown of type MyException, but no exception was thrown.")
	),

	it("should fail if an exception is not thrown of a specific type",
		ex := try(expect(block(YourException raise)) toThrow(MyException))
		expect(ex error) toBe("Expected an exception to be thrown of type MyException, but an exception of type YourException was thrown.")
	),

	it("should be possible to test that an exception with a specific type is thrown",
		matcher := expect(block(MyException raise)) toThrow(MyException)
		expect(matcher success) toBe(true)
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

describe("String diff index",
  it("Should return nil for the same string",
    expect(Matcher stringDiffIndex("abcdef", "abcdef")) toEqual(nil)
  ),

  it("Should return 0 for totally different strings",
    expect(Matcher stringDiffIndex("abcdef", "fedcba")) toEqual(0)
  ),

  it("Should return the first index of different characters for partially similar strings",
    expect(Matcher stringDiffIndex("abcdef", "abcfed")) toEqual(3)
  ),

  it("Should return the size of the first string if the second string has the first as a prefix",
    expect(Matcher stringDiffIndex("abcdef", "abcdefgh")) toEqual(6)
  ),

  it("Should return the size of the second string if the first string has the second as a prefix",
    expect(Matcher stringDiffIndex("abcdefgh", "abcdef")) toEqual(6)
  )
)

describe("toBe Matcher for strings",
	it("can check that two strings are the same",
		expect("Jasmine.Io") toBe("Jasmine.Io")
	),

	it("can determine where two strings differ",
		ex := try(expect("Jasmine.Io") toBe("Jasmine.Js"))	
		expect(ex error) toEqual("Expected Jasmine.Js, but was Jasmine.Io. Strings differ at index 8")
	)	
)

describe("true and false matcher",
	it("can check for true",
		matcher := expect(true) toBeTrue()
		expect(matcher success) toBe(true)
	),

	it("gets correct error message for toBeTrue",
		ex := try(expect(false) toBeTrue())
		expect(ex error) toBe("Expected true, but was false")
	),

	it("can check for false",
		matcher := expect(false) toBeFalse()
		expect(matcher success) toBe(true)
	),

	it("gets correct error message for toBeFalse",
		ex := try(expect(true) toBeFalse())
		expect(ex error) toBe("Expected false, but was true")
	)	
)

describe("List matcher",
	it("can check if an item exists in a list",
		num := list(1, 2, 3, 4, 5)
		expect(num) toContain(1)
	)
)

describe("toHaveSlot matcher",
	it("can find a slot on an object",
		obj := Object clone
		obj foo := nil
		expect(obj) toHaveSlot("foo")
	),

	it("should fail to find a non-existing slot on an object",
		obj := Object clone
		ex := try(expect(obj) toHaveSlot("foo"))
		expect(ex error) toBe("Expected object to have slot foo, but it didn't.")
	)
)

describe("Not matcher",
	it("inverts expectation",
		result := expect(1) not toEqual(2)
		expect(result success) toBe(true)
	),

	it("inverts default error messages",
		ex := try(expect(1) not toBeLessThan(2))
		expect(ex error) toEqual("Expected 1 not to be less than 2")
	)
)

describe("Context handling in matchers",
	it("should evaluate the argument in its existing locals context",
		x := 2
		expect(2) toBe(x) 
	),

	it("should not alter the spec's locals context",
		x := 2
		expect(true) toEqual(true)
		expect(x) toBe(2)
	)
)
