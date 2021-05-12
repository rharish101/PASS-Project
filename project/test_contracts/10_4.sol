pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted 
contract Contract {
  address payable owner;
  function foo(int x) public {
    int y = x;
    if(x < 5) {                   // not guard
      selfdestruct(address(y));   // vulnerable
      if(msg.sender == owner) {   // guard
        // ...
      } else {                    // guard
        // ...
      }
    }
  }
}
