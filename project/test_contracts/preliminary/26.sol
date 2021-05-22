pragma solidity ^0.5.0;

// the contract is vulnerable
// the output of your analyzer should be Tainted
contract Contract {
  address owner;
  address x;
  address y;

  function set_y() public {
    y = msg.sender;
  }

  function bar(int arg) public returns(bool) {
    if (arg > 5) {
      return msg.sender == x;
    } else {
      return msg.sender == y;
    }
  }

  function foo(int i) public {
    require(bar(i)); // not a guard
    selfdestruct(msg.sender); // vulnerable
  }
}
