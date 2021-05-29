pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;

  function a() public {
    b();
    selfdestruct(owner);
  }

  function b() public {
    c();
  }

  function c() public {
    d();
  }

  function d() public {
    // Here we get overflow
    if (true) {
      e();
    } else {
      g();
    }
  }

  function e() public {
    owner = f(msg.sender);
    owner = address(0xDEADBEEF);
  }

  function f(address payable x) public returns (address payable) {
    return x;
  }

  function g() public {
    owner = f(owner);
  }
}
