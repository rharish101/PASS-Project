pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    require(a(x));
    selfdestruct(msg.sender);  // safe
  }

  function a(int x) public returns(bool) {
    if (x > 3) {
      return a(x - 1) || true;
    } else {
      return msg.sender == owner; // guard
    }
  }
}
