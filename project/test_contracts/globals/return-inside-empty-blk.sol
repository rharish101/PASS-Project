pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  int y;
  address owner;
  function foo() public {
    selfdestruct(address(y));  // vulnerable
  }
  function bar(int x) public {
    if (x < 5) {  // not guard
      y = x;  // y becomes perma-tainted
    } else {
      y = 0;
    }
  }
}
