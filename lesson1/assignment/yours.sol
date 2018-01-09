/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract PayrollTest{
    uint salary;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function changeAddress(address e){
            employee = e;
        
    }
    
    function changeSalary(uint s){
        salary = s * 1 ether;
        
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if (msg.sender != employee){
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if ( nextPayDay > now){
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}