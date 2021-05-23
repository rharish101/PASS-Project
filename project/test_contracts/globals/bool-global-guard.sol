pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  bool y;
  function foo() public {
    y = msg.sender == owner;
    if (true) {}
    require(y);                // guard
    selfdestruct(msg.sender);  // safe
  }
}
