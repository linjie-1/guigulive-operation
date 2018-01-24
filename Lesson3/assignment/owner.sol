pragma solidity ^0.4.14;

contract Ownable {
  address public owner;

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(owner == msg.sender);
    _;
  }
}
