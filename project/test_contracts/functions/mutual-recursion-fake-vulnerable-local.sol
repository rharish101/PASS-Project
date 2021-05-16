pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo() public returns (int) {
    int x = bar();
    selfdestruct(address(x));  // safe
    return x;
  }

  function bar() public returns (int) {
    return foo();
  }
}