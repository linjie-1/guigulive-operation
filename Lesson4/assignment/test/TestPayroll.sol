pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {

  function testAddEmployee() public {
    Payroll payroll = Payroll(DeployedAddresses.Payroll());
    payroll.addFund();
    payroll.addEmployee(0x1111, 1);
    payroll.getEmployeeSalary(0x1111);

    Assert.equal(payroll.getEmployeeSalary(0x1111),1,"salay shoud be 1");
    //Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
  }

  function testRemoveEmployee() public {
   Payroll payroll = Payroll(DeployedAddresses.Payroll());
    payroll.addFund();
    payroll.addEmployee(0x1111, 1);
    payroll.removeEmployee(0x1111);
    Assert.equal(payroll.getEmployeeSalary(0x1111),0,"salay shoud be 0");
 }

}
