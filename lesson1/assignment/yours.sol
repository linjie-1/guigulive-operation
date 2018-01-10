pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
        employee = 0x60Dc4b3D8e8d2C5449186270f385a56a21BB82C3;
        salary = 1 ether;
        lastPayday = now;
    }

    function updateAddress(address e) {
        require(employee != e);
        updateEmployee(e, salary);
    }

    function updateSalary(uint s) {
        require(salary != s);
        updateEmployee(employee, s);
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}