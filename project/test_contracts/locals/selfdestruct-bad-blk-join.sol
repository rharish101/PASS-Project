pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    if (x < 6) {
      require(msg.sender == owner);  // guard
    } else {
      selfdestruct(owner);  // bad block dies
    }
    selfdestruct(msg.sender);  // safe
  }
}
