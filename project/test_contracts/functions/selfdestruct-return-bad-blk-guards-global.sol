pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  bool y;

  function foo(int x) public {
    bar(x);
    require(y);  // guard
    selfdestruct(msg.sender);  // safe
  }

  function bar(int x) public {
    if (x < 3) {
      y = msg.sender == owner;  // guard
      return;
    }
    selfdestruct(owner);  // block with y notguard dies
  }
}
