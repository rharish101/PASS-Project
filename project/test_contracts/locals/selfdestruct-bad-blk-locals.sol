pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    address payable y = address(x);
    if (x < 3) {
      require(msg.sender == owner);  // guard
      y = msg.sender;  // force an argument transfer
    } else {
      selfdestruct(owner);  // bad block dies
    }
    selfdestruct(y);  // safe
  }
}
