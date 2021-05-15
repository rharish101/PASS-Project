pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo() public {
    int x = 0xDEADBEEF;
    bar();
    selfdestruct(address(x));  // safe
  }

  function bar() public {
    foo();
  }
}
