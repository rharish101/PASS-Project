pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  int y;
  address owner;
  function foo() public {
    int z = y;  // z becomes perma-tainted
    y = 0;  // y becomes locally clean
    require(msg.sender == owner);  // guard
    selfdestruct(address(z));  // vulnerable
  }
  function bar(int x) public {
    y = x;  // y becomes perma-tainted
  }
}
