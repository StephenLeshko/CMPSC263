// ===========================
// ASYNCHRONOUS PROGRAMMING IN JAVASCRIPT
// Demonstrating Promises, .then/.catch, setTimeout, and Async/Await
// ===========================

// 1. BASICS OF ASYNCHRONY: setTimeout()
// ------------------------------
// JavaScript is single-threaded, but we can execute code asynchronously using setTimeout.

console.log("1. Start");

setTimeout(() => {
    console.log("2. This message is delayed by 2 seconds.");
}, 2000);

console.log("3. End");

// Even though setTimeout() is set to 0ms, it executes after synchronous code.
setTimeout(() => {
    console.log("4. This runs last, despite 0ms delay.");
}, 0);

console.log("5. Synchronous code runs first.");

// Expected Output Order:
// 1. Start
// 3. End
// 5. Synchronous code runs first.
// 4. This runs last, despite 0ms delay.
// 2. This message is delayed by 2 seconds.


// 2. USING PROMISES
// ------------------------------
// A Promise represents a value that might be available in the future.

const myPromise = new Promise((resolve, reject) => {
    setTimeout(() => {
        let success = Math.random() > 0.5; // Random success/failure
        if (success) {
            resolve("✅ Promise resolved successfully!");
        } else {
            reject("❌ Promise was rejected.");
        }
    }, 1500);
});

// Handling a Promise with .then() and .catch()
myPromise
    .then(result => console.log("Promise Result:", result))
    .catch(error => console.error("Promise Error:", error))
    .finally(() => console.log("Promise Completed."));

// Expected Output:
// Either "✅ Promise resolved successfully!" OR "❌ Promise was rejected."
// Followed by "Promise Completed." always.


// 3. FETCH API WITH .THEN() AND .CATCH()
// ------------------------------
// Fetching data from an API and handling the response with .then() and .catch().

console.log("Fetching data...");

fetch("")
    .then(response => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.json();
    })
    .then(data => console.log("Fetched Data:", data))
    .catch(error => console.error("Fetch Error:", error))
    .finally(() => console.log("Fetch request completed."));

// Expected Output:
// "Fetching data..."
// "Fetched Data: {userId: 1, id: 1, title: ..., body: ...}"
// OR "Fetch Error: ..." if the request fails.


// 4. ASYNC/AWAIT FOR BETTER READABILITY
// ------------------------------
// Using async/await instead of .then/.catch for better readability.

async function fetchData() {
    console.log("Fetching data with async/await...");
    try {
        let response = await fetch("");
        if (!response.ok) throw new Error("Network response was not ok");
        
        let data = await response.json();
        console.log("Fetched Data (async/await):", data);
    } catch (error) {
        console.error("Async/Await Fetch Error:", error);
    } finally {
        console.log("Async/Await Fetch Completed.");
    }
}

fetchData();

// Expected Output:
// "Fetching data with async/await..."
// "Fetched Data (async/await): {userId: 1, id: 1, title: ..., body: ...}"
// OR "Async/Await Fetch Error: ..." if request fails.


// 5. CHAINING PROMISES
// ------------------------------
// Running multiple asynchronous operations in sequence.

function delayedMessage(msg, delay) {
    return new Promise(resolve => {
        setTimeout(() => {
            console.log(msg);
            resolve();
        }, delay);
    });
}

console.log("Chaining Promises Start...");

delayedMessage("Message 1 (1s delay)", 1000)
    .then(() => delayedMessage("Message 2 (1.5s delay)", 1500))
    .then(() => delayedMessage("Message 3 (0.5s delay)", 500))
    .then(() => console.log("Chaining Completed."));

// Expected Output:
// "Message 1 (1s delay)"
// "Message 2 (1.5s delay)"
// "Message 3 (0.5s delay)"
// "Chaining Completed."


// 6. ASYNC/AWAIT WITH MULTIPLE ASYNC OPERATIONS
// ------------------------------
// Running multiple async functions sequentially using async/await.

async function runAsyncOperations() {
    console.log("Async/Await Sequential Start...");
    
    await delayedMessage("Async Message 1 (1s delay)", 1000);
    await delayedMessage("Async Message 2 (1.5s delay)", 1500);
    await delayedMessage("Async Message 3 (0.5s delay)", 500);
    
    console.log("Async/Await Sequential Completed.");
}

runAsyncOperations();

// Expected Output:
// "Async/Await Sequential Start..."
// "Async Message 1 (1s delay)"
// "Async Message 2 (1.5s delay)"
// "Async Message 3 (0.5s delay)"
// "Async/Await Sequential Completed."


// ===========================
// SUMMARY
// ===========================
// - setTimeout() schedules tasks asynchronously without blocking execution.
// - Promises allow us to handle asynchronous operations using .then() and .catch().
// - fetch() is used to retrieve data from APIs, returning a Promise.
// - Async/Await provides cleaner syntax to work with Promises.
// - We can chain promises to execute tasks in sequence.
// - Async/Await can also handle sequential execution, making code easier to read.

console.log("End of async programming examples.");
