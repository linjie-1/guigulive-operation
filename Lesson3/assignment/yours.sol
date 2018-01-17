pragma solidity ^0.4.14;

import "http://github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

contract BasePayroll {
    using SafeMath for uint;

    address owner;
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    function BasePayroll() {
        // Assign a contract owner
        owner = msg.sender;
    }

    function addEmployee(address employeeId, uint salary);
    function removeEmployee(address employeeId);
    function updateEmployee(address employeeId, uint salary);
    function changePaymentAddress(address employeeId);

    function addFund() payable external returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        require(totalSalary > 0);

        // return this.balance / totalSalary;
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() external;
}

contract Payroll is BasePayroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    // Employee information
    mapping (address => Employee) private employees;

    modifier onlyOwner {
        // Sender should be the owner
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist(address employeeId) {
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0); // Should be someone
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (
            now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);

        // Add new employee
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);

        // Update total salary
        // totalSalary += salary * 1 ether;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function removeEmployee(address employeeId) onlyOwner
            employeeExist(employeeId) {
        Employee employee = employees[employeeId];

        // Salary settlement
        _partialPaid(employee);

        // Remove employee
        delete employees[employeeId];

        // Update total salary
        // totalSalary -= employee.salary;
        totalSalary = totalSalary.sub(employee.salary);
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner
            employeeExist(employeeId) {
        Employee employee = employees[employeeId];

        // Salary settlement
        _partialPaid(employee);

        // Update total salary
        // totalSalary -= employee.salary;
        totalSalary = totalSalary.sub(employee.salary);

        // Update employee information
        // employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;

        // Update total salary
        // totalSalary += employees[employeeId].salary;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function changePaymentAddress(address employeeId)
            employeeExist(msg.sender) {
        Employee employee = employees[msg.sender];

        // Check employee id
        assert(employees[employeeId].id == 0x0);

        // Add a new entry
        employees[employeeId] = Employee(
            employeeId, employee.salary, employee.lastPayday);

        // Delete the old one
        delete employees[msg.sender];
    }

    function getPaid() employeeExist(msg.sender) external {
        Employee employee = employees[msg.sender];

        // Check payday information
        // uint nextPayday = employee.lastPayday + payDuration;
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        // Check salary balance
        assert(this.balance > employee.salary);

        // Update payday information
        employees[msg.sender].lastPayday = nextPayday;

        // Transfer salary
        employee.id.transfer(employee.salary);
    }
}
