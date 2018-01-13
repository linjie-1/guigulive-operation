pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address owner;
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    // Employee information
    Employee[] employees;

    function Payroll() {
        // Assign a contract owner
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (
            now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; ++i) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        // Sender should be the owner
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);

        // Add new employee
        employees.push(Employee(employeeId, salary, now));

        // Update total salary
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        // Sender should be the owner
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); // Should be someone

        // Salary settlement
        _partialPaid(employee);

        // Remove employee
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;

        // Update total salary
        totalSalary -= employee.salary;
    }

    function updateEmployee(address employeeId, uint salary) {
        // Sender should be the owner
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0); // Should be someone

        // Salary settlement
        _partialPaid(employee);

        // Update total salary
        totalSalary -= employee.salary;

        // Update employee information
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;

        // Update total salary
        totalSalary += employees[index].salary;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        require(totalSalary > 0);

        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0); // Should be someone

        // Check payday information
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        // Check salary balance
        assert(this.balance > employee.salary);

        // Update payday information
        employees[index].lastPayday = nextPayday;

        // Transfer salary
        employee.id.transfer(employee.salary);
    }
}
