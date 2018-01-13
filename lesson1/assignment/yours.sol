/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    address owner;
    
    function Payroll() {
        owner = msg.sender;
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
    
    function setAddress(address newEmployee) {
        require(newEmployee != 0x0 && owner == msg.sender);
        
        employee = newEmployee;
    }
    
    function setSalary(uint newSalary) {
        require(newSalary != 0 && owner == msg.sender);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
        lastPayday = now;
        salary = newSalary * 1 ether;
    }
    
    function getPaid() {
        if (msg.sender != employee) {
            revert();
        }

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
