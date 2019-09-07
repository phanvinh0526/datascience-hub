
const reverseString = require('./reverseString');


// Test 1: Object exist
test("ReverseString function exists", () => {
  expect(reverseString).toBeDefined();
})

// Test 2:
test("String reverse", () =>{
  expect(reverseString('hello')).toEqual('olleh');
})

// Test 3:
