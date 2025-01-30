// Select the sample div and container
const sampleDiv = document.getElementById("sampleDiv");
const demoContainer = document.getElementById("demo-container");

// Append Child Example
function appendChildExample() {
    const newElement = document.createElement("p");
    newElement.textContent = "Appended Child!";
    sampleDiv.appendChild(newElement);
}

// Prepend Example
function prependExample() {
    const newElement = document.createElement("p");
    newElement.textContent = "Prepended Element!";
    sampleDiv.prepend(newElement);
}

// Insert Before Example
function insertBeforeExample() {
    const newElement = document.createElement("p");
    newElement.textContent = "Inserted Before!";
    demoContainer.insertBefore(newElement, sampleDiv);
}

// Remove Child Example
function removeChildExample() {
    if (sampleDiv.lastChild) {
        sampleDiv.removeChild(sampleDiv.lastChild);
    }
}

// Replace Child Example
function replaceChildExample() {
    const newElement = document.createElement("p");
    newElement.textContent = "Replaced!";
    if (sampleDiv.firstChild) {
        sampleDiv.replaceChild(newElement, sampleDiv.firstChild);
    }
}

// Set Attribute Example
function setAttributeExample() {
    sampleDiv.setAttribute("data-demo", "true");
    alert("Attribute 'data-demo' set!");
}

// Remove Attribute Example
function removeAttributeExample() {
    sampleDiv.removeAttribute("data-demo");
    alert("Attribute 'data-demo' removed!");
}

// Modify innerHTML Example
function modifyInnerHTMLExample() {
    sampleDiv.innerHTML = "<b>Modified innerHTML!</b>";
}

// Modify textContent Example
function modifyTextContentExample() {
    sampleDiv.textContent = "Modified textContent!";
}

// Clone Node Example
function cloneNodeExample() {
    const clone = sampleDiv.cloneNode(true);
    clone.id = "clonedDiv";
    demoContainer.appendChild(clone);
}

// Toggle Class Example
function toggleClassExample() {
    sampleDiv.classList.toggle("highlight");
}
