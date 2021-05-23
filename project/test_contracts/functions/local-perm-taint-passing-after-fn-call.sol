pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo() public {
    address payable x = owner;
    bar();
    selfdestruct(x);  // vulnerable
  }

  function bar() public { }

  function baz() public {
    owner = msg.sender;
  }
}
