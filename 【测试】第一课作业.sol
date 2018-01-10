
// 第一课作业
pragma solidity ^0.4.14;
contract Payroll {
    uint salary = 1 ether;
    // 默认转账地址
    address person = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    // 设置地址
    function setAddress(address addr) {
        person = addr;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function colculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function get() returns (uint)  {
        return this.balance;
    }

    function hasEnoughFund() returns (bool) {
        return colculateRunway() > 0;
    }
    // 
    function getPaid() {
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay < now) {
            lastPayday = nextPayDay;
            person.transfer(salary);
        }
      
    }

}