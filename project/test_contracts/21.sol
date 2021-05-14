pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    owner = address(x);
    owner = address(clean());
    selfdestruct(owner);  // safe
  }

  function clean() public returns(int) {
    return 0xDEADBEEF;
  }
}
