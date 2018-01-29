pragma solidity ^0.4.14;

contract Owner {
  address public owner;

  function Owner() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(owner == msg.sender);
    _;
  }
}
