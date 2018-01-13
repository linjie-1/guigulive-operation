pragma solidity ^0.4.14;

contract Payroll {
    address owner;
    uint constant payDuration = 10 seconds;

    // Employee information
    address employee;
    uint salary;
    uint lastPayday;

    function Payroll() {
        // Assign a contract owner
        owner = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        // Sender should be the employee
        require(msg.sender == employee);

        // 0. Original version
        // Check payday information
        // uint nextPayday = lastPayday + payDuration;
        // assert(nextPayday < now);

        // Update payday information
        // lastPayday = nextPayday;

        // Transfer salary
        // employee.transfer(salary);

        // 1. Updated version
        // Check number of pay durations
        uint numPayCycle = (now - lastPayday) / payDuration;
        assert(numPayCycle >= 1); // At least one duration

        // Update payday information
        lastPayday += numPayCycle * payDuration;

        // transfer salary
        employee.transfer(salary * numPayCycle);
    }

    function updateEmployeeAddress(address e) {
        // Sender should be the owner
        require(msg.sender == owner);

        // Check if addresses are the same
        require(e != employee);

        if (employee != 0x0) {
            // Pay salary before change an existing employee
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        // Update employee
        employee = e;
        salary = 1 ether; // Default salary
        lastPayday = now;
    }

    function updateEmployeeSalary(uint s) {
        // Sender should be the owner
        require(msg.sender == owner);

        // Check salary range
        require(s >= 0);

        if (employee != 0x0) {
            // Pay salary before change an existing employee
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        // Update salary
        salary = s * 1 ether;
        lastPayday = now;
    }
}
