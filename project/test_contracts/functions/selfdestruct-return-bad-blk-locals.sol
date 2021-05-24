pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    address payable y = bar(x);  // returns from good block only
    selfdestruct(y);  // safe
  }

  function bar(int x) public returns (address payable) {
    if (x < 3) {
      require(msg.sender == owner);  // guard
      return msg.sender;
    }
    selfdestruct(owner);  // bad block dies
  }
}
