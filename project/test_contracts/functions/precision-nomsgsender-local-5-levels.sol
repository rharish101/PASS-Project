pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  bool y;
  
  function f1() public {
    y = owner == msg.sender;
    require(f2());
    selfdestruct(msg.sender);  // safe
  }

  function f2() public returns(bool) {
    return f3();
  }

  function f3() public returns(bool) {
    return f4();
  }

  function f4() public returns(bool) {
    return f5();
  }

  function f5() public returns(bool) {
    return y;
  }
}
