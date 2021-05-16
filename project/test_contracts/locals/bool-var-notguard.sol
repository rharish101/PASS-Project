pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Vulnerable
contract Contract {
  address owner;
  function foo() public {
    bool y = owner == owner;
    require(y || true);                   // not guard
    selfdestruct(msg.sender);             // vulnerable
  }
}
