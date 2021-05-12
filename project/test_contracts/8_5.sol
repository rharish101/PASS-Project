pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  int y;
  int z;
  address owner;
  function foo() public {
    y = z;  // y becomes perma-tainted
    y = 0;  // y becomes clean
    require(msg.sender == owner);  // guard
    selfdestruct(address(y));  // safe
  }
  function bar(int x) public {
    z = x;  // z becomes perma-tainted
  }
}
