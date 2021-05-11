pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address owner;
  function foo() public {
    bool y = msg.sender == owner;
    require(y || true);                   // is it a guard?
    selfdestruct(msg.sender);             // safe or vulnerable?
  }
}
