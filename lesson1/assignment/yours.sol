/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract payroll{
    unit constant payDuration = 10 seconds;
    
    address owner;
    unit salary;
    address employee;
    unit lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeAddress(address e) {
        employee = e;
    }
    
    function updateEmployeeSalary(unit s){
        salary = s;
    }
    
    function updateEmployee(address e, unit s) {
        require(msg.sender == owner);
        
        if (employee != e) {
            unit payment = salary * (now-lastPayday)/payDuration
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday=now;
    }
    
    funtion addFund() payable returns (unit) {
        return this.balance;
    }
    
    funtion calculateRunway() returns (unit) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        unit nextPayday = lastPayday + payDuration;
        assert(nestPayday < now);
        
        lastPayday = nestPayday;
        employee.transfer(salary)
    }
}

