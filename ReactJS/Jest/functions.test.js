
const functions = require('./functions');


// RUN Test: before & after each test function
// beforeEach(() => initDatabase());
// afterEach(() => closeDatabase());

// RUN Test: before & after running all functions in this module
// beforeAll(() => initDatabase());
// afterAll(() => closeDatabase());

// RUN Test: for a defined function in this module
  // BeforeEach now is ONLY run twice (Jeff & Karen), 
    // only INSIDE the describe block
const nameCheck = () => console.log("Checking name...");

describe("Checking names", () => {
  beforeEach(() => nameCheck());

  test("User is Jeff", () => {
    const user = 'Jeff';
    expect(user).toBe('Jeff');
  });

  test("User is Karen", () => {
    const user = "Karen";
    expect(user).toBe("Karen");
  });
})


const initDatabase = () => console.log("Database initialized...");
const closeDatabase = () => console.log("Database closed...");


// --- Write the first test ---
test('Adds 2 + 2 to equal 4', () => {
  expect(functions.add(2, 2)).toBe(4);
  
});

test('Adds 2 + 2 to not equal 5', () => {
  expect(functions.add(2, 2)).not.toBe(5);
  
});


//--------------------------------------
// toBeNull to check NULL
// toBeUndefined matches only null
// toBeDefined is the opposite of toBeUndefined
// toBeTruthy matches anything that an if statement treats as true
// toBeFalsy matches anything that an if statement treats as false
//--------------------------------------

// toBeNull
test('Should be null', () => {
  expect(functions.isNull()).toBeNull();
});

// toBeFalsy
test('Should be falsy', () => {
  expect(functions.checkValue(undefined)).toBeFalsy(); // null is falsy
});

// toBe is for string / numberic
test('Should be be Brad Traversy object', () => {
  expect(functions.createUser()).toEqual({
    firstName: 'Brad',
    lastName: 'Traversy'
  });
});

// Less than and greater than
test('Should be under 1600', () => {
  const load1 = 800;
  const load2 = 700;
  expect(load1 + load2).toBeLessThanOrEqual(1600);
});

// Regex
test('There is no I in team', () => {
  expect('team').not.toMatch(/I/i); // Lower and upper case
});

// Arrays
test('Admin should be in usernames', () => {
  usernames = ['john', 'karen', 'admin'];
  expect(usernames).toContain('admin');
});


// Promise
test('API Promise: User fetched name should be Leanne Graham', () => {
  expect.assertions(1);
  return functions.fetchUser().then(data => {
    expect(data.name).toEqual("Leanne Graham");
  })

});

// Working with async data - Async Await
test('API Async: User fetched name should be Leanne Graham', async () => {
  expect.assertions(1);
  const data = await functions.fetchUser();
  expect(data.name).toEqual("Leanne Graham");
});