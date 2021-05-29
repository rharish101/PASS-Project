pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;

  function f1() public {
    owner = msg.sender;
    f2();
    selfdestruct(msg.sender);  // safe
  }

  function f2() public {
    f3();
  }

  function f3() public {
    f4();
  }

  function f4() public {
    f5();
  }

  function f5() public {
    require(msg.sender == owner); // guard because msg.sender == msg.sender
  }
}
