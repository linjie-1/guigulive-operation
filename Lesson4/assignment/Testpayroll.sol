pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/payroll.sol";

contract Testpayroll is  payroll{
  function testaddEmployee() public {
    payroll payRoll = payroll(DeployedAddresses.payroll());

    bool addcheck = addemployee(0x583031d1113ad415f02576bd6afabfb302140223,1);

    uint expectedsalary = 1 ether ;
    address expectedid = 0x583031d1113ad415f02576bd6afabfb302140223;
    
    Assert.equal(addcheck, true, "the employee is already added.");

    Assert.equal(es[expectedid].salary, expectedsalary, "the employee added and the salary is 1 ether.");
  }


  function testremoveemployee() public {
    var e=es[0x583031d1113ad415f02576bd6afabfb302140223];

    //Assert.equal(e.id, 0x583031d1113ad415f02576bd6afabfb302140223, "the employee is not exist");

    removeemployee(e.id);
    Assert.equal(es[e.id].id, 0x0, "the employee is not exist");
  }
}
