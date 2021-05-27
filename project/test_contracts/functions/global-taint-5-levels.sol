pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  address payable owner2;
  function f1() public {
    owner = msg.sender;
    address payable x = f2();
    owner = address(0xDEADBEEF);
    owner2 = address(0xDEADBEEF);
    selfdestruct(x);  // vulnerable
  }

  function f2() public returns(address payable) {
    return f3();
  }

  function f3() public returns(address payable) {
    return f4();
  }

  function f4() public returns(address payable) {
    return f5();
  }

  function f5() public returns(address payable) {
    owner2 = owner;
    return owner2;
  }
}
