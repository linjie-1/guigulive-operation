pragma solidity ^0.4.14;
contract Yours {
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    uint salary;
    address owner;
    address employee;

    function Yours() {
        owner = msg.sender;
    }

    function addFond() payable returns (uint) {
        return this.balance;
    }

    function showEmployee() returns (address) {
        return employee;
    }

    function updateSalary(uint s) {
        require(owner == msg.sender);
        salary = s * 1 ether;
    }

    function updateEmployee(address e) {
        require(owner == msg.sender);
        employee = e;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() returns (uint) {
        require (msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;

        require (nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}