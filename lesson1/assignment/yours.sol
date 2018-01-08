/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function setAddress(address newEmployee) {
        if(newEmployee == 0) {
            revert();
        }
        
        employee = newEmployee;
    }
    
    function setSalary(uint newSalary) {
        if(newSalary == 0) {
            revert();
        }
        
        salary = newSalary;
    }
    
    function getPaid() {
        if (msg.sender != employee) {
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
