pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable user;
  address payable owner;

  function registerUser() public {
    user = msg.sender;
  }

  function changeOwner(address payable newOwner) public {
    require(msg.sender == user); // not a guard
    owner = newOwner;
  }

  function kill() public {
    selfdestruct(owner); // vulnerable
  }
}
