pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  address payable y;

  function foo(int x) public {
    bar(x);  // returns from good block only
    selfdestruct(y);  // vulnerable
  }

  function bar(int x) public {
    if (x < 3) {
      require(msg.sender == owner);  // guard
      return;
    }
    selfdestruct(owner);  // bad block dies
  }

  function baz() public {
    y = msg.sender; // perma-tainted
  }
}
