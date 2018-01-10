pragma solidity ^0.4.0;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address newEmployee) {
        require(msg.sender == owner);
        
        employee = newEmployee;
        lastPayday = now;
    }
    
    function updateSalary(uint newSalary) {
        require(msg.sender == owner);
        salary = newSalary * 1 ether;
    
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
