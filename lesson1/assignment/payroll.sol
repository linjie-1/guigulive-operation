pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    address employee;
    uint lastPayDay;
    uint salary;
    
    event Salary(address employee, uint salary);
    
    function Payroll() {
        owner      = msg.sender;
        salary     = 1 ether;
        lastPayDay = now;
    }
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        employee = e;
    }
    
    function updateSalary(uint s) returns (bool) {
        require(msg.sender == owner);
        
        uint newSalary = s * 1 ether;
        
        if(salary == newSalary) { revert(); }
        
        uint payment = salary * (now - lastPayDay) / payDuration; // 部分结算上一次工资；
        Salary(employee, payment);
        salary     = newSalary;
        lastPayDay = now;
        employee.transfer(payment);
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
        Salary(employee, salary);
    }
}
