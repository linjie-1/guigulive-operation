pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayRoll.sol";


contract TestPayRoll {

  function testAddEmployee() public {
    Payroll payroll = Payroll(DeployedAddresses.Payroll());


  }

}
