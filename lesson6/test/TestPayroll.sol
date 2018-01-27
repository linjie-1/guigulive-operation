pragma solidity ^0.4.4;

import "truffle/Assert.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {

  function testAddEmployee() {
    Payroll payroll = new Payroll();
    address addressId = "0x58100fdb2b03966c4c8b000ba88a8f13852aee3d";
    uint salary = 2;
    payroll.addEmployee(addressId, salary);

    Assert.equal(payroll.employees[addressId].salaryInMonth, salary, "The employee's salary should be 2 ether");
  }

  function testRemoveEmployee() {
    Payroll payroll = new Payroll();
    address id = "0x58100fdb2b03966c4c8b000ba88a8f13852aee3d";
    payroll.removeEmployee(id);

    Assert.equal(payroll.employees[id].id, "0x0", "The employee's should have been removed!");
  }
}