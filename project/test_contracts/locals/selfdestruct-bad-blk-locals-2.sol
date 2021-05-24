pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  int z;

  function foo(int x) public {
    address payable y = address(z);
    if (x < 3) {
      selfdestruct(owner);
    } else {
      selfdestruct(owner);
    }
    selfdestruct(y);  // vulnerable, but dead code, so safe
  }

  function bar(int x) public {
    z = x;
  }
}
