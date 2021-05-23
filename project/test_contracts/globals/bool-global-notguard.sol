pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address owner;
  bool y;
  function foo() public {
    y = owner == owner;
    require(y);                // not guard
    selfdestruct(msg.sender);  // vulnerable
  }
}
