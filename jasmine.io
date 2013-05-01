Matcher := Object clone

Matcher toEqual := method(expected,
  if(actual == expected, return true)
  self message := "Expected " .. expected .. " (" .. expected type .. "), but was " .. actual .. " (" .. actual type .. ")"
  false
)

Matcher toBe := method(expected,
  if(expected type == Sequence type,
    toBeString(expected),
    toEqual(expected))
)

Matcher toBeTrue := method(
  if(actual,
    return true,
    self message := "Expected true, but was false"
    return false)
)

Matcher toBeFalse := method(
  if(actual == false,
    return true,
    self message := "Expected false, but was true"
    return false)
)

Matcher stringDiffIndex := method(string1, string2,
  if(string1 == string2, return nil)
  index := 0

  // Special case for string2 having string1 as a prefix
  if (string2 beginsWithSeq(string1),
    index = string1 size,

    // Otherwise we do a normal search
    string1 foreach(i, char,
      index = i
      if(string2 at(i) isNil or string1 at(i) asCharacter != string2 at(i) asCharacter, 
        break
      )
    )
  )
  index
)

Matcher toBeString := method(expected,
  if(expected == actual, return true)
  self message := "Expected " .. expected .. ", but was " .. actual .. ". Strings differ at index " .. stringDiffIndex(expected, actual)
  false
)

Matcher toContain := method(expected,
  actual contains(expected)
)

Matcher toBeNil := method(
  if(actual == nil, return true)
  self message := "Expected nil, but was " .. actual
  false
)

Matcher toThrowWithMessage := method(expected,
  ex := try(actual call)
  if(ex == nil,
    self message := "Expected an exception to be thrown with message '" .. expected .. "', but no exception was thrown."
    return false,
    if(ex error != expected,
      self message := "Expected an exception to be thrown with message '" .. expected .. "', but an exception with message '" .. ex error .. "' was thrown."
      return false,
      return true
    )
  )
)

Matcher toThrowWithType := method(expected,
  ex := try(actual call)
  if(ex == nil,
    self message := "Expected an exception to be thrown of type " .. expected type .. ", but no exception was thrown."
    return false,
    if(ex type != expected type,
      self message := "Expected an exception to be thrown of type " .. expected type .. ", but an exception of type " .. ex type .. " was thrown."
      return false,
      return true
    )
  )
)

Matcher toThrow := method(expected,
  if(expected != nil,
    if(expected type == Sequence type,
      return toThrowWithMessage(expected),
      return toThrowWithType(expected)
    )
  )

  ex := try(actual call)
  if(ex == nil,
    self message := "Expected an exception to be thrown, but no exception was thrown."
    return false,
    return true
  )
)

Matcher toHaveSlot := method(expected,
  if (actual hasSlot(expected), return true)
  self message := "Expected object to have slot " .. expected .. ", but it didn't."
  false
)

Matcher message := method(inverted,
  "Expected " .. actual .. if(inverted, " not ", " ") .. expectation fromCamelCaseToSentence .. " " .. expected
)

Matcher toHaveBeenCalled := method(
  if(actual calls size > 0, return true)
  self message := "Expected spy to have been called"
  false
)

Matcher toHaveBeenCalledWith := method(
  expectedArglist := call message argsEvaluatedIn(call sender)
  prefix := "Expected spy to have been called with " .. expectedArglist

  if(actual calls size == 0,
    self message := prefix .. " but it wasn't called."
    return false
  )

  args := actual calls last
  if (args != expectedArglist,
    self message := prefix .. " but it was called with " .. args .. "."
    return false
  )
  true
)

Sequence fromCamelCaseToSentence := method(
  output := ""
  self foreach(i, char,
    if(char asCharacter isUppercase,
      output = output asMutable appendSeq(" ", char asCharacter lowercase),
      output = output asMutable appendSeq(char asCharacter)
    )
  )
  output
)

expect := method(actual,
  wrapper := Object clone
  wrapper inverted := false
  wrapper actual := actual

  wrapper not := method(
    self inverted := true
    self
  )

  wrapper forward := method(
    matcher := Matcher clone
    matcher actual := actual
    matcher expected := call message arguments at(0)
    matcher expectation := call message name
    matcher success := call delegateTo(matcher)

    if(inverted, matcher success := if(matcher success, false, true))
    if(matcher success == false, Exception raise(matcher message(inverted)))
    matcher
  )

  wrapper
)

spyOn := method(obj, methodName,
  if(obj == nil, Exception raise("Can't spy on nil"))
  if(methodName == nil, Exception raise("Method name wasn't passed to spyOn"))
  spy := Spy clone
  spy obj := obj
  spy name := methodName
  obj setSlot(spy realMethodSlotName, obj getSlot(methodName))

  obj setSlot(methodName, method(
    call delegateToMethod(self, "run")
  ))
  obj getSlot(methodName) setScope(spy)
  spy
)

Spy := Object clone

Spy init := method(
  self calls := List clone
  self forwardTo := nil
)

Spy run := method(
  // Evaluate the arguments in the context of the sender. This isn't always the right
  // thing to do in Io since some methods evaluate their arguments in the receiver's
  // context. But it's what we'd expect in the vast majority of cases where spies 
  // are useful.
  arglist := call message argsEvaluatedIn(call sender)
  self calls append(arglist)
  if(self forwardTo,
    call delegateToMethod(self forwardTo at(0), self forwardTo at(1))
    // We haven't been configured to do anything, so just return
    // what would be the real method's "self".
    self obj)
)

Spy realMethodSlotName := method(
  "_jasmine_spy_" .. self name
)

Spy andCallThrough := method(
  self forwardTo := list(self obj, self realMethodSlotName)
  self
)

Spy andForwardTo := method(target, methodName,
  self forwardTo := list(target, methodName)
  self
)

Spy andCallFake := method(blockToCall,
  self forwardTo := list(blockToCall, "call")
)

// isSpy is just an aid to the Jasmine tests for spies.
Spy isSpy := true

Spec := Object clone
Spec run := method(
  ex := try(doMessage(test))
  if(ex == nil,
    self message := "",
    self message := ex error)
  self
)

Suite := Object clone
Suite beforeEach := method()
Suite afterEach := method()
Suite run := method(
  specs foreach(spec,    
    (beforeEach != nil) ifTrue (doMessage(beforeEach))
    spec run
    (afterEach != nil) ifTrue (doMessage(afterEach))
  )
)

Jasmine := Object clone
Jasmine suites := List clone
Jasmine clone := Jasmine

describe := method(description,
  suite := Suite clone
  specs := List clone

  suite description := description
  suite specs := specs

  args := call message arguments
  args removeFirst

  args foreach(arg,    
    if(arg name beginsWithSeq("x"), continue)

    if(arg name beginsWithSeq("beforeEach"),      
      suite beforeEach := arg arguments at(0)
      continue)

    if(arg name beginsWithSeq("afterEach"),
      suite afterEach := arg arguments at(0)
      continue)  

    specDescription := arg arguments at(0) asString asMutable removePrefix("\"") removeSuffix("\"")
    spec := Spec clone
    spec description := specDescription
    spec test := arg arguments at(1)
    specs append(spec)
  )

  Jasmine suites append(suite)
  suite
)

xdescribe := method(nil)

# Colors
colors := Object clone do(
  red   := "[0;31m"
  green := "[0;32m"
  # more colors at http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
)

colors slotNames foreach(color,
  colorCode := colors getSlot(color)
  Sequence setSlot(color, method(
    27 asCharacter .. self .. call target .. 27 asCharacter .. "[0m"
  ) setScope(colorCode))
)

# Runner
files := List clone
runnerArguments := System args rest map(item,
  Directory currentWorkingDirectory asMutable appendSeq("/", item))

Directory with(Directory currentWorkingDirectory) walk(item,
  if(item name endsWithSeq("_spec.io") and (runnerArguments size == 0 or runnerArguments contains(item path)),
    files append(item path))
)

files foreach(filename,
  ex := try(doFile(filename))
  if(ex != nil,
    writeln("Error loading spec file: " .. filename)
    writeln("Message: " .. ex error .. "\n")
  )
)

suiteFailures := Jasmine suites map(suite,
  suite run
  suite description println

  suite specs foreach(spec,
    if(spec message isEmpty,
      ("  ✓ " .. spec description) green println
      ,
      ("  ✖ " .. spec description) red println
      ("    " .. spec message) red println)
  )

  success  := suite specs select(spec, spec message isEmpty) size
  failures := suite specs size - success

  report := "Results: " .. suite specs size .. " specs, " .. failures .. " failures"

  writeln()
  if(failures > 0, report red println, report green println)
  writeln()

  failures
)

// If there's more than one suite, report the overall results.
if(Jasmine suites size > 1,
	totalSpecs := Jasmine suites map(s, s specs size) reduce(+)
	totalFailures := suiteFailures reduce(+)
	report := "Overall results: " .. totalSpecs .. " specs, " ..  totalFailures .. " failures"

	if(totalFailures > 0, report red println, report green println)
)
