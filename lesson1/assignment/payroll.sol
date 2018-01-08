pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    address employee;
    uint lastPayDay;
    uint salary;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        employee   = e;
        salary     = s * 1 ether;
        lastPayDay = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        require(salary > 0);
        
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayDay = lastPayDay + payDuration;
        
        if (nextPayDay > now) { revert(); }
        
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
}
