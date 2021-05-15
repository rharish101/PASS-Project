pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo() public {
    require(a());
    selfdestruct(msg.sender);  // safe
  }

  function a() public returns(bool) {
    return msg.sender == owner || a(); // guard
  }
}
