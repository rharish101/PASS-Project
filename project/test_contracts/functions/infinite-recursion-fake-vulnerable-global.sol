pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo() public {
    owner = msg.sender;  // tainted
    owner = address(0xDEADBEEF);  // clean
    foo();
    selfdestruct(owner);  // safe
  }
}
