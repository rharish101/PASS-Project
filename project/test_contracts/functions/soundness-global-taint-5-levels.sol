pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  address payable owner2;
  function f1() public {
    owner = msg.sender;
    f2();
    selfdestruct(owner2);  // vulnerable
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
    owner2 = owner;
  }
}
