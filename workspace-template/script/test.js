const npp = require('#menu-helper');

console.log('NppMenuScripts JavaScript Helper test');

for (let count = 1; count <= 3; count++) {
  console.log(`Test ${count}`);
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
}

console.log('Current file:', npp.getFileName());

const cursor = npp.getCursor();
console.log(`Cursor: line ${cursor.line}, column ${cursor.column}`);

const selection = npp.getSelection();
console.log(npp.hasSelection()
  ? `Selected text: ${selection}`
  : 'No text is selected.');

const name = npp.prompt('Enter your name:', 'JavaScript', undefined, '?');
if (name !== null) {
  console.log(`Hello, ${name}!`,'i');
  if (npp.confirm('Set a message in the Notepad++ status bar?', undefined, 'i')) {
    npp.setStatusBarText(`Hello, ${name}!`);
  }
}

npp.alert('JavaScript Helper API test completed.',undefined,'!');
