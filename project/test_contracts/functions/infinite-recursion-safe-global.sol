pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo() public {
    owner = address(0xDEADBEEF);
    foo();
    selfdestruct(owner);  // safe
  }
}
