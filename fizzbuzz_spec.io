getFizzBuzz := method(number,
	if(number % 3 == 0 and number % 5 == 0 , return "FizzBuzz")
	if(number % 3 == 0, return "Fizz")
	if(number % 5 == 0, return "Buzz")
	number
)

describe("FizzBuzz",
	it("Should return Fizz for divisible of three",
		equals("Fizz", getFizzBuzz(3))
	),

	it("Should return Buzz for divisible of five",
		equals("Buzz", getFizzBuzz(5))
	),

	it("Should return FizzBuzz for divisible of three and five",
		equals("FizzBuzz", getFizzBuzz(15))
	),

	it("Should return number if not divisible by three or five",
		equals(2, getFizzBuzz(2))
	)
)