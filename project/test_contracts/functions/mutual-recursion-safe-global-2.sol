pragma solidity ^0.5.0;

// the contract is safe
// the output of your analyzer should be Safe
contract Contract {
  address payable owner;
  function foo(int x) public {
    if (x > 3) {
      bar(x - 1);
      selfdestruct(owner);  // safe
    }
  }

  function bar(int x) public {
    owner = msg.sender;  // tainted
    owner = address(0xDEADBEEF);  // clean
    foo(x);
  }
}
