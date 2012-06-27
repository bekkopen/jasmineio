getFizzBuzz := method(number,
	if(number % 3 == 0 and number % 5 == 0 , return "FizzBuzz")
	if(number % 3 == 0, return "Fizz")
	if(number % 5 == 0, return "Buzz")
	number
)

describe("FizzBuzz",
	it("Should return Fizz for divisible of three",
		expect(getFizzBuzz(3)) toBe("Fizz")
	),

	it("Should return Buzz for divisible of five",
		expect(getFizzBuzz(5)) toBe("Buzz")
	),

	it("Should return FizzBuzz for divisible of three and five",
		expect(getFizzBuzz(15)) toBe("FizzBuzz")
	),

	it("Should return number if not divisible by three or five",
		expect(getFizzBuzz(2)) toBe(2)
	)
)