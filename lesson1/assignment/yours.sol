pragma solidity ^0.4.0;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address newEmployee, uint newSalary) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = newEmployee;
        salary = newSalary * 1 ether;
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
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
