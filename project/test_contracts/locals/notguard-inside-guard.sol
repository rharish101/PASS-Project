pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe 
contract Contract {
  address payable owner;
  function foo() public {
    if(owner == msg.sender) {      // guard
      if(owner == owner) {         // not guard
        selfdestruct(msg.sender);  // safe
      }
    }
  }
}
