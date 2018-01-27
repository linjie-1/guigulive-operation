pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleStorage.sol";

contract TestSimpleStorage is SimpleStorage{

  // function testItStoresAValue() public {
  //   SimpleStorage simpleStorage = SimpleStorage(DeployedAddresses.SimpleStorage());

  //   simpleStorage.set(89);

  //   uint expected = 89;

  //   Assert.equal(simpleStorage.get(), expected, "It should store the value 89.");
  // }

  function testItStoresAValue() public {
    
    setInternal.set(89);

    uint expected = 89;

    Assert.equal(get(), expected, "It should store the value 89.");
  }


}
