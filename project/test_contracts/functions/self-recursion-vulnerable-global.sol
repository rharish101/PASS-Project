pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public {
    owner = address(x);
    if (x > 3) {
      foo(x - 1);
      selfdestruct(owner);  // vulnerable
    }
  }
}
