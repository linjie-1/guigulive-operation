/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll{
    uint salary;
    address employee;
    uint constant payDuration=10 seconds;
    uint lastPayDay;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    function updateEmployees (address e,uint s){
        employee=e;
        salary=s;
        lastPayDay=now;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance/salary;
    }
    function hasEnoughFund() returns (bool) {
       // return this.balance >= salary;
       return calculateRunway() >= 0;
    }
    function getPaid(){
        if(msg.sender!=employee){
            revert();
        }

        uint nextPayDay=lastPayDay+payDuration;
        
        if (nextPayDay>now){
           revert();
        }
        lastPayDay=nextPayDay;
        employee.transfer(salary);
    }
}
