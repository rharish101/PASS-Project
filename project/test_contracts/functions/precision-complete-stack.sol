pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function f1() public {
    selfdestruct(f2(owner));  // safe
  }

  function f2(address payable x) public returns(address payable) {
    return f3(x);
  }

  function f3(address payable x) public returns(address payable) {
    return f4(x);
  }

  function f4(address payable x) public returns(address payable) {
    return f5(x);
  }

  function f5(address payable x) public returns(address payable) {
    return x;
  }
}
