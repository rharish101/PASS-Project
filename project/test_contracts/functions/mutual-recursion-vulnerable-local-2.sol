pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public returns (int) {
    int y = x;
    y = bar(y);
    selfdestruct(address(y));  // vulnerable
    return y;
  }

  function bar(int x) public returns (int) {
    return foo(x);
  }
}
