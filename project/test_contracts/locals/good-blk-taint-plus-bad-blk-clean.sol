pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  function foo(int x) public {
    if (x < 6) {
        require(msg.sender == owner); // guard
    } else {
        x = 5;
    }
    selfdestruct(address(x));          // safe
  }
}
