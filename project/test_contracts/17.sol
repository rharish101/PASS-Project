pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  int y;
  address owner;
  function foo() public {
    y = 0;  // y becomes locally clean
    selfdestruct(address(y));  // safe
  }
  function bar(int x) public {
    y = x;  // y becomes perma-tainted
  }
}
