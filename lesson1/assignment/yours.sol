pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address owner = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday;

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

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

    function checkNewSalary() returns (uint){
        return salary;
    }
}

