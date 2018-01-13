pragma solidity ^0.4.14;

contract Payroll {
    uint salary;
    address boss;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() {
        boss = msg.sender;
    }
    
    function updateEmployeeAddress(address a) {
        require(msg.sender == boss);
        
         if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = a;
        lastPayday = now;
    }
    
    function updateEmployeeSalary(uint s) {
        require(msg.sender == boss);
        
	if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        lastPayday = now;
        salary = s * 1 ether;
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
