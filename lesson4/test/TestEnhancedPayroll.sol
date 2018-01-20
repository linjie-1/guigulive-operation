pragma solidity ^0.4.4;

import "truffle/Assert.sol";
import "../contracts/EnhancedPayroll.sol";

contract TestEnhancedPayroll {

  function testAddEmployee() {
    EnhancedPayroll payroll = new EnhancedPayroll();
    var addressId = "0x58100fdb2b03966c4c8b000ba88a8f13852aee3d";
    uint salary = 2;
    payroll.addEmployee(addressId, salary);

    Assert.equal(payroll.employees[addressId].salaryInMonth, salary, "The employee's salary should be 2 ether");
  }

  function testRemoveEmployee() {
    EnhancedPayroll payroll = new EnhancedPayroll();
    address id = "0x58100fdb2b03966c4c8b000ba88a8f13852aee3d";
    payroll.removeEmployee(id);

    Assert.equal(payroll.employees[id].id, "0x0", "The employee's should have been removed!");
  }
}
