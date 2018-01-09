/*作业请提交在这个目录下*/

pragma solidity ^0.4.19;

contract Payroll {
    uint constant payDuration = 10 seconds;

    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
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
    
    function updateAddress(address e) {
        if(e == 0x0) {
            revert();
        }
        
        employee = e;
    }
    
    function updateSalary(uint s) {
        if(s <= 0) {
            revert();
        }
        
        salary = s;
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
