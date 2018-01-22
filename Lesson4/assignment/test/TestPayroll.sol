pragma solidity ^0.4.14;

import "truffle/Assert.sol";
import "../contracts/Payroll.sol";

contract TestPayroll is Payroll {
  address employeeAddr = 0x3d8b7addb54eea6a20f9bfe683c483d20357a742;
  
  function t0estAddEmployee() public {
    uint oldTotalSalary = totalSalary;
    uint salary = 33;
    addEmployee(employeeAddr, salary);
    // Assert.notEqual(employees[employeeAddr].id, "0x0", "should contains added address");
    Assert.equal(employees[employeeAddr].salary, salary, "The employee should have setted salary");
    Assert.equal(oldTotalSalary+salary, totalSalary, "totalSalary should been added up");
  }

  /*function testRemoveEmployee() public {
    Employee employee = employees[employeeAddr];
    Assert.notEqual(employee.id, 0x0, "Target employee exists before removing");
    uint balanceBeforeRemove = this.balance;
    uint totalSalaryBeforeRemove = this.totalSalary;
    var shouldPayDuration = 5 seconds;
    employee.lastPayDay = now - shouldPayDuration;
    uint shouldPay = shouldPayDuration * employee.salary;
    removeEmployee(employeeAddr);
    Assert.equal(employees[employeeAddr].id, 0x0, "Target employee not exists after removing");
    Assert.equal(totalSalaryBeforeRemove - employee.salary, totalSalary, "totalSalary should cut down");
    Assert.equal(balanceBeforeRemove - shouldPay, this.balance, "balance should cut down");
  }*/
}