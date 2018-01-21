pragma solidity ^0.4.14;

import './Owner.sol';
import './SafeMath.sol';

contract Payroll is Owner {
    using SafeMath for uint;
    struct Employee {
      address id;
      uint salary;
      uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    address owner;
    mapping (address => Employee) employees;
    uint totalSalary = 0;

    modifier employeeExist(address employeeId) {
      var employee = employees[employeeId];
      assert(employee.id != 0x00);
      _;
    }

    function _partialPaid(Employee employee) private {
      //uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
      uint payment = now.sub(employee.lastPayday).mul(employee.salary).div(payDuration);
      employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id == 0x00);

      employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
      totalSalary = totalSalary.add(employee.salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
      var employee = employees[employeeId];

      _partialPaid(employee);
      totalSalary = totalSalary.sub(employee.salary);
      delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
      var employee = employees[employeeId];

      _partialPaid(employee);
      totalSalary = totalSalary.sub(employee.salary);
      employee.salary = salary.mul(1 ether);
      employee.lastPayday = now;
      totalSalary = totalSalary.add(employee.salary);
    }

    function changePaymentAddress(address newEmployeeId) employeeExist(msg.sender) {
      var employee = employees[msg.sender];

      employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, now);
      delete employees[msg.sender];
    }

    function addFund() payable returns (uint) {
      return this.balance;
    }

    function calculateRunway() returns (uint) {
      return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
      return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) {
      var employee = employees[msg.sender];

      uint nextPayday = employee.lastPayday + payDuration;
      assert(nextPayday < now);

      employee.lastPayday = nextPayday;
      employee.id.transfer(employee.salary);
    }
}
