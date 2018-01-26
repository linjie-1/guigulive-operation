pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
  address constant newEmployeeId = 0x123;
  uint constant expectedSalary = 1 ether;

  // Hard to test duplicate situation in solidity test and non owner situation
  function testAddEmployeeWithNewPayroll() public {
    /* Payroll payroll = Payroll(DeployedAddresses.Payroll()); */
    Payroll payroll = new Payroll();

    payroll.addEmployee(newEmployeeId, 1);
    var (salary, _) = payroll.checkEmployee(newEmployeeId);
    Assert.equal(salary, expectedSalary, "It should add the new employee and set salary.");
    Assert.equal(payroll.getTotalSalary(), expectedSalary, "It should increase total salary.");
  }

  function testRemoveEmployeeWithNewPayroll() public {
    Payroll payroll = new Payroll();

    payroll.addEmployee(newEmployeeId, 1);
    payroll.removeEmployee(newEmployeeId);
    var (salary, _) = payroll.checkEmployee(newEmployeeId);
    Assert.notEqual(salary, expectedSalary, "It should add the new employee and set salary.");
    Assert.equal(payroll.getTotalSalary(), 0, "It should deduct removed employee salary from total salary.");
  }
}
