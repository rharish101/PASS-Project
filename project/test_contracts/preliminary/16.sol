pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable user;
  address payable owner;

  function registerUser() public payable {
    if (msg.value < 5) {
        user = address(0xDEADBEEF);
    } else {
        user = msg.sender;
    }
  }

  function kill() public {
    require(msg.sender == user); // not a guard
    selfdestruct(msg.sender); // vulnerable
  }
}
