pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";
import "../contracts/Owner.sol";

contract TestSimpleStorage is Payroll {
  address testEmployeeId = 0x1166fdf965cdd024bf6e7c520dc0f3ff3ec94d19;
  uint testSalary = 1 ether;

  function testAddEmployeeFunc() public {
    addEmployee(testEmployeeId, 1);

    Assert.equal(employees[testEmployeeId].salary, testSalary, "It should scary the value 1.");
  }

  function testRemoveEmployeeFunc() public {
    removeEmployee(testEmployeeId);

    Assert.equal(employees[testEmployeeId].id, 0x00, "It should delete employee");
  }
}
