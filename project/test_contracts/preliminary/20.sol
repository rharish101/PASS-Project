pragma solidity ^0.5.0;

// the contract is safe 
// the output of your analyzer should be Safe
contract Contract {
  address a;
  address payable owner;

  function set_a() public {
    a = msg.sender; // a becomes trusted after seeing the guard
    require(msg.sender == owner); // guard
  }

  function bar() public {
    require(msg.sender == a); // guard
    selfdestruct(msg.sender); // safe
  }
}
