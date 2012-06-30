#Jasmine.Io
**A Io Language Testing Framework**

Jasmine.Io is a [Io Language](http://www.iolanguage.com) port of the popular Behavior Driven Development testing framework for JavaScript.

The project was implemented as a learning exercise after reading the [7 languages in 7 weeks book](http://pragprog.com/book/btlang/seven-languages-in-seven-weeks), where Io is the second language introduced. The implementation makes relies on Io's strong metaprogramming capabilities..

## Example specification and usage ##
```Io
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
```

You execute the spec by calling ``$ Io jasmine.io fizzbuzz_spec.io``. If you do not specify a spec-file to run, Jasmine.Io will recursively walk your working directory, executing any file name ending with ``_spec.io``.

```
$ Io jasmine.io fizzbuzz_spec.io 
FizzBuzz
  ✓ Should return Fizz for divisible of three: passed
  ✓ Should return Buzz for divisible of five: passed
  ✓ Should return FizzBuzz for divisible of three and five: passed
  ✓ Should return number if not divisible by three or five: passed

Results: 4 specs, 0 failures
```

## Contributors ##
- [Trond Klakken](https://twitter.com/trondkla)
- [Mikkel Dan-Ronglie](https://twitter.com/mikkelbd/)
- [Torgeir Thoresen](https://twitter.com/torgeir)
- [Eivind Sorteberg](https://twitter.com/sorteberg)
- [Jonas Follesø](https://twitter.com/follesoe)





