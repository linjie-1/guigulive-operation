  pragma solidity ^0.4.14;

 contract PayRoll {
     uint salary = 1 ether;
     address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
     address frank = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
     uint constant duration = 10 seconds;
     uint lastpayday = now;

     function addFund() payable returns (uint) {
         return this.balance;
     }

     function calculateRunway() returns (uint) {
         return this.balance / salary;
     }

     function hasEnoughfund() returns (bool) {
         return calculateRunway() > 0;
     }

     function getPaid() {
         require(msg.sender == frank);
         uint nextPayday = lastpayday + duration;
         require(nextPayday < now);
         lastpayday = nextPayday;
         frank.transfer(salary);
     }

     function changeAddress(address addr) {
         require(addr == owner && addr != 0x0);
         frank = addr;
     }

     function changeSalary(uint target) {
         require(msg.sender == owner && target > 0);
         salary = target;
     }
 }

