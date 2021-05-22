pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address owner;
  int x;

  function set_x(int i, int j) public {
    int a = i + j;
    int b = i / j;
    int c = i * j;
    int d = i - j;
    if (i == j) {
      x = a * b;
    } else {
      x = c + d;
    }
    require(msg.sender == owner); // guard
  }

  function foo() public {
    bool b = (msg.sender == owner || x == 10);
    require(b); // guard
    selfdestruct(msg.sender); // safe
  }
}
