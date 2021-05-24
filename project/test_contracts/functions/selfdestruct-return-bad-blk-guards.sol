pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;

  function foo(int x) public {
    require(bar(x));  // returns from good block only
    selfdestruct(msg.sender);  // safe
  }

  function bar(int x) public returns (bool) {
    if (x < 3) {
      return msg.sender == owner;  // guard
    }
    selfdestruct(owner);  // bad block dies
  }
}
