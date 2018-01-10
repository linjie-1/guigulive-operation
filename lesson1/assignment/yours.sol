pragma solidity ^0.4.14;

contract Payroll {
    // change address and salary
    
    uint salary  ;
    address frank ;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setSalary (uint m) {
        salary = m;
    }
    
    function setAddress(address a) {
        frank = a;
    }
    
    function addFund () payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if (msg.sender != frank) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if ( nextPayday > now) {
            revert();
        }
        // the order matters
            lastPayday = nextPayday;
            frank.transfer(salary);

    }
    
}
