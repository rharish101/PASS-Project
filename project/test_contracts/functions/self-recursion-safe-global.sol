pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    owner = address(0xDEADBEEF);
    if (x > 3) {
      foo(x - 1);
      selfdestruct(owner);  // safe
    }
  }
}
