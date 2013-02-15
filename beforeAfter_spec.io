someList := List clone

describe("before and after each spec",
  beforeEach(
    someList append(1)
  ),
  
  afterEach(
    someList remove(1)
  ),

  it("Should populate the list variable with one item",
    expect(someList size) toBe(1)
  ),

  it("Should contain the item 1",
    expect(someList contains 1) toBe(1)
  )
)