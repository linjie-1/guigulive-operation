pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address payAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function setAddress(address x){
        payAddress = x;
    }
    
    function setSalary(uint x){
        salary = x;
    }
    
    function getPaid(){
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now){
            revert();
        }
        
        lastPayday = nextPayDay;
        payAddress.transfer(salary);
    }
}
