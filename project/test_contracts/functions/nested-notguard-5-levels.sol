pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address payable owner;
  function foo(int x) public {
    require(a(x));
    selfdestruct(msg.sender);  // vulnerable
  }

  function a(int x) public returns(bool) {
    return b(x);
  }

  function b(int x) public returns(bool) {
    return c(x);
  }

  function c(int x) public returns(bool) {
    return d(x);
  }

  function d(int x) public returns(bool) {
    return e(x);
  }

  function e(int x) public returns(bool) {
    return msg.sender == address(x);
  }
}
