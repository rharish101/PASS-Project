pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;

  function foo(int x) public {
    require(bar(x));  // returns from good block only
    selfdestruct(msg.sender);  // vulnerable
  }

  function bar(int x) public returns (bool) {
    if (x < 3) {
      return owner == owner;  // guard
    }
    selfdestruct(owner);  // bad block dies
  }
}
