pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    address empolyee;
    uint salary;
    uint lastPayday = now;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (salary == 0) {
            revert();
        }
        
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function setEmpolyeeInfo(address newEmpolyee, uint newSalary) {
        if (msg.sender != owner) {
            revert();
        }
        
        empolyee = newEmpolyee;
        salary = newSalary * 1 ether;
    }
    
    function getPaid() returns (uint) {
        if (msg.sender != empolyee) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        empolyee.transfer(salary);
    }
}
