pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;

  function f1(int x) public {
    owner = address(x);
    f2();
    selfdestruct(msg.sender);  // vulnerable
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
    require(msg.sender == owner);
  }
}
