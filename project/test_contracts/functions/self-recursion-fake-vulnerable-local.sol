pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public returns (int) {
    int y = 0xDEADBEEF;
    if (x > 3) {
      y = foo(x - 1);
      selfdestruct(address(y));  // safe
    }
    return y;
  }
}
