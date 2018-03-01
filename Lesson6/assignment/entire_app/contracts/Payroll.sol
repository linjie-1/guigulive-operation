pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 days;
    uint totalSalary;
    uint totalEmployees;

    mapping(address => Employee) public employees;
    address[] employeeList;

    event NewEmployee(
      address employee
    );

    event UpdateEmployee(
      address employee
    );

    event RemoveEmployee(
      address employee
    );

    event NewFund(
      uint balance
    );

    event GetPaid(
      address employee
    );

    modifier onlyEmployee {
        Employee employee = employees[msg.sender];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeExists(address employeeId) {
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint partialPayment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        assert(this.balance >= partialPayment);

        employee.lastPayday = now;
        employee.id.transfer(partialPayment);
    }

    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        Employee employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);

        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);
        employeeList.push(employeeId);
        totalSalary = totalSalary.add(salary);
        totalEmployees = totalEmployees.add(1);
        NewEmployee(employeeId);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);

        totalSalary = totalSalary.sub(employee.salary);
        totalEmployees = totalEmployees.sub(1);
        delete employees[employeeId];
        
        for (uint index = 0; index < employeeList.length; index++) {
          if (employeeList[index] == employeeId) {
            delete employeeList[index];
            employeeList[index] = employeeList[employeeList.length - 1];
            employeeList.length--;
          }
        }

        RemoveEmployee(employeeId);
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);

        uint newSalary = salary.mul(1 ether);
        totalSalary = totalSalary.add(newSalary).sub(employee.salary);
        employees[employeeId].salary = newSalary;
        UpdateEmployee(employeeId);
    }

    function changeEmployeeAddress(address newEmployeeId) onlyEmployee {
        Employee employee = employees[msg.sender];

        employee.id = newEmployeeId;
        employees[newEmployeeId] = employee;
        delete employees[msg.sender];
    }

    function addFund() payable onlyOwner returns (uint) {
        NewFund(this.balance);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        if (totalSalary > 0) {
          runway = calculateRunway();
        }
        employeeCount = totalEmployees;
    }

    function getPaid() onlyEmployee returns (Employee) {
        Employee employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        assert(this.balance >= employee.salary);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        GetPaid(employee.id);
    }
}