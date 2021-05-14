pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    owner = address(x);
    clean();
    selfdestruct(owner);  // safe
  }

  function clean() public {
    owner = address(0xDEADBEEF);
  }
}
