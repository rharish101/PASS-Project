pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public returns (int) {
    int y = x;
    if (x > 3) {
      y = foo(y - 1);
      selfdestruct(address(y));  // vulnerable
    }
    return y;
  }
}
