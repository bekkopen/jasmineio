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
      if(string2 at(i) isNil or
  string1 at(i) asCharacter != string2 at(i) asCharacter,
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
    matcher success := matcher doMessage(call message, actual)

    if(inverted, matcher success := if(matcher success, false, true))
    if(matcher success == false, Exception raise(matcher message(inverted)))
    matcher
  )

  wrapper
)

Spec := Object clone
Spec run := method(
  ex := try(doMessage(test))
  if(ex == nil,
    self message := "",
    self message := ex error)
  self
)

Suite := Object clone
Suite run := method(
  specs foreach(spec,
    spec run
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
    specDescription := arg arguments at(0) asString asMutable removePrefix("\"") removeSuffix("\"")
    spec := Spec clone
    spec description := specDescription
    spec test := arg arguments at(1)
    if(arg name beginsWithSeq("x"), continue, specs append(spec))
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

Jasmine suites foreach(suite,
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
)
