pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public {
    int y = x;
    if(x < 5) {                   // not guard
      y = 5;
    }
    require(owner == owner);     // not guard
    selfdestruct(address(y));    // vulnerable
  }
}
