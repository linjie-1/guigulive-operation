pragma solidity ^0.4.14;

contract Payroll {
    address dong;
    address frank;
    uint salary = 1 ether;
    uint lastPayDay = now;
    uint constant payDuration = 10 seconds;
    
    function Payroll(address frankAddress){
        dong = msg.sender;
        frank = frankAddress;
    }
    
    function changeFrank(address newFrank){
        if (msg.sender != dong)
            revert();
        frank = newFrank;
    }
    
    function changeSalary(uint newSalary){
        if (msg.sender != dong)
            revert();
        salary = newSalary;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function getPaid() {
        if (msg.sender != frank)
            revert();
            
        uint nextPayDay = lastPayDay + payDuration;
        if (nextPayDay > now)
            revert();
            
        lastPayDay = nextPayDay;
        frank.transfer(salary);
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
}
