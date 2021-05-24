pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public {
    require(a(x));
    selfdestruct(msg.sender);  // vulnerable
  }

  function a(int x) public returns(bool) {
    if (x > 3) {
      return a(x - 1) || (x == 3); // not guard
    } else {
      return msg.sender == owner; // guard
    }
  }
}
