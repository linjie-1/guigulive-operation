pragma solidity ^0.4.14;

contract Payroll {
    uint payDuration = 10 seconds;
    
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 10 ether;
    uint lastPayDate = now;
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
        return calculateRunway() >= 1;
    }
    
    function updateEmployee(address e) {
        if (owner != msg.sender) {
            revert();
        }
        employee = e;
    }
    
    function updateEmployeeSalary(uint s) payable {
        if (owner != msg.sender) {
            revert();
        }
        if (employee != address(0x0)) {
            uint leftPayment = salary * (now - lastPayDate) / payDuration;
            employee.transfer(leftPayment);
        }
        salary = s;
        lastPayDate = now;
    }
    
    function getPaid() payable {
        if (employee != address(0x0) && employee != msg.sender) {
            revert();
        }
        
        uint nextPayDate = lastPayDate + payDuration;
        if (now < nextPayDate) {
            revert();
        } 
        nextPayDate = now;
        employee.transfer(salary);
    }
}