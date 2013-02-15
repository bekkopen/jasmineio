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

## Custom Matchers ##
Extending Jasmine.Io with custom matchers are dead simple. You simply add a new method to the Matcher prototype that evaluates to true or false. Jasmine.Io will generate resenoable error messages automatically, or you can choose to customize the error message yourself.

```Io
Matcher toBeLessThan := method(expected, actual < expected)

Matcher toBeGreaterThan := method(expected,
	if(actual > expected, return false)
	self message := actual .. " is not greater than " .. expected
	false
)

describe("Custom matchers",
	it("is possible to add matchers by adding a method to the Matcher prototype",
		expect(1) toBeLessThan(2)		
	),	

	it("should error messages generated automatically",
		expect(2) toBeLessThan(1)
	),

	it("is possible to customize the error message if you want to",
		expect(1) toBeGreaterThan(2)
	)
)
```

```
$ Io jasmine.io matcher_spec.io 
Custom matchers
  ✓ is possible to add matchers by adding a method to the Matcher prototype: passed
  ϰ should error messages generated automatically: Expected 2 to be less than 1
  ϰ is possible to customize the error message if you want to: 1 is not greater than 2

Results: 3 specs, 2 failures
```

## Spies ##
Jasmine.io supports spies, which allow you to record and verify calls made to a method:

```io
spy := spyOn(target, "writeln")
target doSomething
expect(spy) toHaveBeenCalledWith("the value we expect")
```

You can also inspect the spy's `calls` property, which is a list with one element per call received. Each element is a list of arguments. If you want to call the real method in addition to recording calls, use `andCallThrough`. You can also use `andForwardTo` to call any method on any object or `andCallFake` to call a block:

```io
spy := spyOn(target, "writeln") andCallThrough
// Alternately:
spy := spyOn(target, "writeln") andForwardTo(someObject, "someMethodName")
// Alternately:
spy := spyOn(target, "writeln") andCallFake(block(/* do something */))
target doSomething 
expect(spy) toHaveBeenCalledWith("the value we expect")
```

```
$ io jasmine.io spy_spec.io 
Spies
  ✓ should throw if the object is nil
  ✓ should throw if the method name is nil
  ✓ should provide the spy in the method's scope slot
  ✓ should start with an empty call list
  ✓ should store the arguments used to call the spy

Results: 5 specs, 0 failures

toHaveBeenCalled matcher
  ✓ should succeed if the spy was called
  ✓ should fail if the spy wasn't called

Results: 2 specs, 0 failures

toHaveBeenCalledWith matcher
  ✓ should succeed if the spy was called with the right arguments
  ✓ should fail if the spy wasn't called
  ✓ should fail if the spy was called with the wrong arguments

Results: 3 specs, 0 failures
```

## Contributors ##
- [Trond Klakken](https://twitter.com/trondkla)
- [Mikkel Dan-Rognlie](https://twitter.com/mikkelbd/)
- [Torgeir Thoresen](https://twitter.com/torgeir)
- [Eivind Sorteberg](https://twitter.com/sorteberg)
- [Jonas Follesø](https://twitter.com/follesoe)
- [Johannes Hoff](http://johanneshoff.com/)
- [Ryan Leavengood](https://twitter.com/leavengood)
- [Steve Gravrock](https://github.com/sgravrock)