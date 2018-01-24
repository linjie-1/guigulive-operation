pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleStorage.sol";

contract TestSimpleStorage is SimpleStorage{

  function testItStoresAValue() {
    setInternal(89);
    Assert.equal(get(), 89, "It should store the value 89.");
  }

}
