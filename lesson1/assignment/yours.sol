/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract payroll{
    uint salary = 1 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address boss  = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() returns(uint){
        if (msg.sender != frank) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        
        if(nextPayday > now ){
            revert();
        }
        
        lastPayday = nextPayday;
        frank.transfer(salary);
        return frank.balance;
    }
    
    function changeAddress(address newAddress) {
        if(msg.sender != frank){  //only frank can change his salary address;
            revert();
        }
        frank = newAddress;
    }
    
    function changeSalary(uint newSalary) payable{
        //only boss can change the salary
    
        if(msg.sender != boss) throw;
        if(newSalary <= 0) throw;
        
        salary = newSalary;
    }
}
