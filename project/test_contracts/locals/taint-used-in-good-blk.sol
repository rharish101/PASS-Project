pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe 
contract Contract {
  address payable owner;
  function foo(int x) public {
    int y = x;
    if(x < 5) {                   // not guard
      if(msg.sender == owner) {   // guard
        selfdestruct(address(y)); // safe
        // ...
      } else {                    // guard
        // ...
      }
    }
  }
}
