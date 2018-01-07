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
        employee = e;
        lastPayday = now;
        
        //先把之前的工资发掉
        if (oldEmployee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            oldEmployee.transfer(payment);
        }else{
            revert();
        }
       
    }
    
    function updateEmployeeSalary(uint s) public {
        require(msg.sender == owner);
        
        uint oldSalary = salary;
        salary = s * 1 ether;
        lastPayday = now;
        
        //先把之前的工资发掉
        if (employee != 0x0) {
            uint payment = oldSalary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }else{
            revert();
        }
       
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

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
