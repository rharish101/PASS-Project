pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public returns (int) {
    if (x > 3) {
      int y = bar(x - 1);
      selfdestruct(address(y));  // vulnerable
    }
    return x;
  }

  function bar(int x) public returns (int) {
    return foo(x);
  }
}
