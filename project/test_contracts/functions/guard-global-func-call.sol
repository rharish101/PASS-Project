pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  bool y;
  function check(address x) public {
    y = msg.sender == x;  // guard
  }
  function foo() public {
    y = owner == owner;  // not guard
    check(owner);
    require(y);  // guard
    selfdestruct(msg.sender);  // safe
  }
}
