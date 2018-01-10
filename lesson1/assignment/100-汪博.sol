pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address employer=0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee=0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayDay = now;
    uint salary = 1 wei;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function askSalary() returns (uint){
        
        require(msg.sender == employer || msg.sender == employee);
        return salary;
    }
    
    
    
    function changeSalary(uint salaryNew){
        
        require(msg.sender == employer);
        
        if (employee != 0x0) {
            uint salaryTmp = salary * (now - lastPayDay) / payDuration;
            employee.transfer(salaryTmp);
        }
        
        salary = salaryNew;
    }
    
    function changeEmployee(address employeeNew){
        
        require(msg.sender == employer);
        employee = employeeNew;
    }
    
    function changeEmployer(address employerNew){//sell company
        
        require(msg.sender == employer);
        employer = employerNew;
    }
    

    
    
    
    function askNextPayDay() returns (uint){
        return lastPayDay + payDuration;
    }
    
    
    function calculateRunAway() returns (uint){
        return this.balance/salary;
    }
    
    function enoughFund() returns (bool){
        return calculateRunAway() >= 1;
    }
    
    function getPaid() {
        uint nextPayDay = lastPayDay + payDuration;
        
        require(msg.sender == employee && nextPayDay<=now );

        uint salaryTmp = salary*((now-lastPayDay)/payDuration);
        lastPayDay = now;
        employee.transfer(salaryTmp);// allow get paid after several duration
    }
}