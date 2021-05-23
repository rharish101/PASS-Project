pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address owner;
  bool y;
  function check(address x) public {
    y = x == x;  // not guard
  }
  function foo() public {
    y = msg.sender == owner;  // guard
    check(owner);
    require(y);  // not guard
    selfdestruct(msg.sender);  // vulnerable
  }
}
