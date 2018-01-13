pragma solidity ^0.4.14;

contract Payroll {
  struct Employee {
    address addr;
    uint salary;
    uint lastPayday;
  }

  uint constant payDuration = 10 seconds;

  address owner;

  Employee[] employees;

  function Payroll() {
    owner = msg.sender;
  }

  function _partialPaid(Employee employee) private {
    uint amount = employee.salary * (now - employee.lastPayday) / payDuration;
    employee.addr.transfer(amount);
  }

  function _findEmployee(address employeeAddr) private returns (Employee, uint) {
    for (uint i = 0; i < employees.length; i ++) {
      if (employees[i].addr == employeeAddr) {
        return (employees[i], i);
      }
    }
  }

  function addEmployee(address employeeAddr, uint salary) {
    require(msg.sender == owner);
    require(salary > 0);
    var (duplicate, _) = _findEmployee(employeeAddr);
    assert(duplicate.addr == 0x0);
    employees.push(Employee(employeeAddr, salary, now));
  }

  function removeEmployee(address employeeAddr) {
    require(msg.sender == owner);
    var (employee, id) = _findEmployee(employeeAddr);
    assert(employee.addr != 0x0);

    _partialPaid(employee);
    employees[id] = employees[employees.length - 1];
    delete employees[employees.length - 1];
    employees.length -= 1;
  }

  function updateEmployee(address employeeAddr, uint salary) {
    require(msg.sender == owner);
    require(salary > 0);
    var (employee, id) = _findEmployee(employeeAddr);
    assert(employee.addr != 0x0);

    _partialPaid(employee);
    employees[id].salary = salary;
    employees[id].lastPayday = now;
  }

  function addFund() payable returns (uint) {
    return this.balance;
  }

  function calculateRunway() returns (uint) {
    uint totalSalary = 0;
    for (uint i = 0; i < employees.length; i++) {
      totalSalary += employees[i].salary;
    }
    return this.balance / totalSalary;
  }

  function hasEnoughFund() returns (bool) {
    return calculateRunway() > 0;
  }

  function getPaid() {
    for (uint i = 0; i < employees.length; i++) {
      uint nextPayday = employees[i].lastPayday + payDuration;
      if (nextPayday < now) {
        employees[i].addr.transfer(employees[i].salary);
      }
    }
  }
}
