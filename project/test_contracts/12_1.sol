pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  function foo() public {
    bool y = msg.sender == owner;
    require(y || true);                   // guard
    selfdestruct(msg.sender);             // safe
  }
}
