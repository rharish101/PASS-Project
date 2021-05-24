pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  address payable y;

  function foo(int x) public {
    if (x < 3) {
      require(msg.sender == owner);  // guard
      y = address(x);
    } else {
      selfdestruct(owner);  // bad block dies
    }
    selfdestruct(y);  // safe
  }

  function bar() public {
    y = msg.sender; // perma-tainted
  }
}
