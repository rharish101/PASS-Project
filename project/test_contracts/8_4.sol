pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  int y;
  int z;
  address owner;
  function foo(int x) public {
    x = z;  // x becomes perma-tainted
    y = x;
    require(msg.sender == owner);  // guard
    selfdestruct(address(y));  // vulnerable
  }
  function bar(int x) public {
    z = x;  // z becomes perma-tainted
  }
}
