pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeAddress(address addr) {
        require(msg.sender == owner);
        require(addr != 0x0);
        employee = addr;
    }
    
    function updateEmployeeSalary(uint s) {
        require(msg.sender == owner);
        salary = s;
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
        assert(hasEnoughFund());

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}