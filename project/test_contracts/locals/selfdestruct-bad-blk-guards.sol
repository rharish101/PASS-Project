pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;

  function foo(int x) public {
    bool y = true;
    if (x < 3) {
      y = msg.sender == owner;  // guard
    } else {
      selfdestruct(owner);  // block with y notguard dies
    }
    require(y);  // guard
    selfdestruct(msg.sender);  // safe
  }
}
