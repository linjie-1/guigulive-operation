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
        if(msg.sender != employer && msg.sender != employee)revert();
        return salary;
    }
    
    
    
    function changeSalary(uint salaryNew){
        if(msg.sender!=employer)revert();
        salary = salaryNew;
    }
    
    function changeEmployee(address employeeNew){
        if(msg.sender!=employer)revert();
        employee = employeeNew;
    }
    
    function changeEmployer(address employerNew){//sell company
        if(msg.sender!=employer)revert();
        employer = employerNew;
    }
    

    
    
    
    function askNextPayDay() returns (uint){
        return lastPayDay + payDuration;
    }
    
    
    function calculateRunAway() returns (uint){
        return this.balance/salary;
    }
    
    function enoughFund() returns (bool){
        return calculateRunAway()>=1;
    }
    
    function getPaid() {
        uint nextPayDay = lastPayDay + payDuration;
        if(msg.sender != employee || nextPayDay>now ){
            revert();
        }
        uint salaryTmp = salary*((now-lastPayDay)/payDuration);
        lastPayDay = now;
        employee.transfer(salaryTmp);// allow get paid after several duration
    }
}