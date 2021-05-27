pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function f1(int x) public {
    selfdestruct(f2(x));  // safe
  }

  function f2(int x) public returns(address payable) {
    return f3(x);
  }

  function f3(int x) public returns(address payable) {
    return f4(x);
  }

  function f4(int x) public returns(address payable) {
    if (x < 3) {
      return f5(owner);
    } else {
      return f6();
    }
  }

  function f5(address payable x) public returns(address payable) {
    return x;
  }

  function f6() public returns(address payable) {
    return owner;
  }
}
