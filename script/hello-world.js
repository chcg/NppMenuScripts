console.log('hello from stdout');
console.error('hello from stderr');
console.log('Current test: Output Pane should display stdout / stderr in real time.');
// The Output Pane supports basic ANSI color codes only; it is not a full terminal emulator.
console.log('\x1b[32mhello from ANSI green\x1b[0m normal text');

let count = 0;
const timer = setInterval(() => {
  console.log(new Date().toLocaleString('en-US', {
    hour12: false
  }));
  count++;
  if (count >= 5) {
    clearInterval(timer);
    console.log('test completed!');
  }
}, 1000);
