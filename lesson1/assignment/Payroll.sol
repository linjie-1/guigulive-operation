pragma solidity ^0.4.14;
contract Payroll {
    
    uint salary = 1 wei;
    address constant ceo = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x0;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() returns(uint) {
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns(bool) { 
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if(employee==0x0 || msg.sender != employee) {
            revert();
        }
        
        if(lastPayday + payDuration > now) {
            revert();
        }
        
        lastPayday = lastPayday + payDuration;
        employee.transfer(salary);
        
    }
    
    function setSalary(uint x) returns (uint) {
        require(msg.sender == ceo);
           
        salary = x;
        return salary;
    }
    
    function setEmployee(address x) returns(address) {
        require(msg.sender == ceo);
        
        employee = x;
        return employee;
    }
}