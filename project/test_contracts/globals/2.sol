pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  function changeOwner() public {
    owner = address(0xDEADBEEF);
  }
  function foo() public {
    require(msg.sender == owner); // guard
    selfdestruct(msg.sender);     // safe
  }
}
