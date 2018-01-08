pragma solidity ^0.4.14;

contract payRoll{
    uint salary = 1 ether;
    address wallet = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 30 days;
    uint lastPayday = now;
    
    function getWallet() {
        wallet = msg.sender;
    }
    
    function addFund() returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if(msg.sender != wallet){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        wallet.transfer(salary);
    }
    
}