pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  int y;
  function foo(int x) public {
    y = y + x;
    y = y - x;  // y is untrusted
  }
}
