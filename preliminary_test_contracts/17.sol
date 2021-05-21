pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  int y;
  address payable owner;
  address payable admin;

  function foo(int x) public {
    y = x; // y becomes trusted after seeing the guard
    require(msg.sender == owner); // guard
  }

  function bar() public {
    bool b = (msg.sender == owner || y < 10);
    if (b) { // guard
      selfdestruct(admin); // safe
    } else {
      selfdestruct(msg.sender); // safe
    }
  }
}
