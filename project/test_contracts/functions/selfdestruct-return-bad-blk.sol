pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    bar(x);
    selfdestruct(msg.sender);  // safe
  }

  function bar(int x) public {
    if (x < 3) {
      require(msg.sender == owner);  // guard
      return;
    }
    selfdestruct(owner);  // bad block dies
  }
}
