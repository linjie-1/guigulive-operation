pragma solidity ^0.4.14;
contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayDay = now;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return caculateRunway() > 0;
    }
    
    function updateEmployee(address e, uint s) {
        if (msg.sender != owner) {
            revert();
        }
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayDay) / payDuration;
            employee.transfer(payment);
        }
        employee = e;
        salary = s;
        lastPayDay = now;
    }
    
    function getPaid() {
        if (msg.sender != employee) {
            revert();
        } 
        uint nextPayDay = lastPayDay + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
}