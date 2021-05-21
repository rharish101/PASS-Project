pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address owner;
  function check(address x) public returns(bool) {
    return (msg.sender == x);
  }
  function foo() public {
    require(check(owner));         // guard
    selfdestruct(msg.sender);      // safe
  }
  function bar(address z) public {
    require(check(z));             // not a guard
    selfdestruct(msg.sender);      // vulnerable
  }
}
