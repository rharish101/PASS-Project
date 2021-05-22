pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address a;
  address b;
  address c;

  function set_rec(int i, address x) public {
    if (i <= 0) {
      a = x;
      b = x;
    } else {
      set_rec(i-1, x);
    }
  }

  function foo() public {
    require(msg.sender == a); // not a guard
    selfdestruct(msg.sender); // vulnerable
  }
}
