pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  bool y;
  
  function f1() public {
    f2(owner == msg.sender);
    require(y);
    selfdestruct(msg.sender);  // safe
  }

  function f2(bool x) public {
    f3(x);
  }

  function f3(bool x) public {
    f4(x);
  }

  function f4(bool x) public {
    f5(x);
  }

  function f5(bool x) public {
    y = x;
  }
}
