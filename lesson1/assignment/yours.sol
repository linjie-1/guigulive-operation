  pragma solidity ^0.4.14;

 contract PayRoll {
     uint salary = 1 ether;
     address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
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
         if(msg.sender != frank) {
             revert();
         }
         uint nextPayday = lastpayday + duration;
         if (nextPayday >= now) {
             revert();
         }
         lastpayday = nextPayday;
         frank.transfer(salary);
     }

     function changeAddress() {
         frank = msg.sender;
     }

     function changeSalary() {
         if (msg.value <= 0) {
             revert();
         }
         salary = msg.value;
     }
 }
