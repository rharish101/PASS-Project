pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  function foo(address x) public {
    bool y = msg.sender == owner;  // guard
    bool z = msg.sender == x;  // not guard
    if (true) {
      require(y);  // guard
      y = z;  // y and z are now guards
    }
    require(y);  // guard
    selfdestruct(msg.sender);  // safe
  }
}
