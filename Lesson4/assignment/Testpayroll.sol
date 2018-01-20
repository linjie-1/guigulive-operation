pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/payroll.sol";

contract Testpayroll is  payroll{
  function testaddEmployee() public {
    payroll payRoll = payroll(DeployedAddresses.payroll());

    payRoll.addemployee(0x583031d1113ad415f02576bd6afabfb302140223,1);

    uint expectedsalary = 1  ;
    address expectedid = 0x583031d1113ad415f02576bd6afabfb302140223;

    Assert.equal(es[expectedid].slaray, expectedsalary, "the employee added and the salary is 1 ether.");
  }

  

}
