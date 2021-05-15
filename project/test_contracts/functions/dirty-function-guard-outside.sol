pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    dirty(x);
    require(msg.sender == address(0xDEADBEEF));
    selfdestruct(owner);  // safe
  }

  function dirty(int x) public {
    owner = address(x);
  }
}
