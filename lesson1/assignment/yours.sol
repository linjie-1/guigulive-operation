pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
        salary = 10;
        employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        lastPayday = now;
    }
    
    function getAddress() returns (address){
        return employee;
    }
    
    function updateEmployeeAddress(address e) public {
        require(msg.sender == owner);
        
        address oldEmployee = employee;
       
        //先把之前的工资发掉
        if (oldEmployee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            oldEmployee.transfer(payment);
        } 
        
         employee = e;
        lastPayday = now;
        
       
    }
    
    function updateEmployeeSalary(uint s) public {
        require(msg.sender == owner);
        
        uint oldSalary = salary;
       
        //先把之前的工资发掉
        if (employee != 0x0) {
            uint payment = oldSalary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        salary = s * 1 ether;
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
        require(msg.sender == owner);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        if(employee != 0x0){
            lastPayday = nextPayday;
            employee.transfer(salary);
        }
    }
}
