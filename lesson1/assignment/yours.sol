pragma solidity ^0.4.14;

contract Payroll {
    uint salary;
    address boss;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() {
        boss = msg.sender;
    }
    
    function updateEmployee(address a, uint s) {
        if (msg.sender != boss) {
            revert();
        }
        
        employee = a;
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
        if(msg.sender != employee) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}