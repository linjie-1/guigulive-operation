/*作业请提交在这个目录下*/

pragma solidity ^0.4.19;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday = now;
    
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
    
    function updateAddress(address e) {
        if(employee == e) {
            revert();
        }
        
        updateEmployee(e, salary);
    }
    
    function updateSalary(uint s) {
        if(s <= 0) {
            revert();
        }
        
        updateEmployee(employee, s);
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
