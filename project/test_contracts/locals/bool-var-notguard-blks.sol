pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Vulnerable
contract Contract {
  address owner;
  function foo() public {
    bool x;
    if (true) {
      x = owner == owner;
    } else {
      x = msg.sender == owner;
    }
    require(x);                           // not guard
    selfdestruct(msg.sender);             // vulnerable
  }
}
