pragma solidity ^0.4.14;

contract Palyroll {
  uint salary = 1 ether  ;
  address employeeAddr = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c ;
  address employerAddr ;
  uint constant payPeriod = 10 seconds;
  uint lastPayday  = now;


  function addFund() payable returns(address){
    employerAddr = msg.sender;
    return employerAddr;
  }

  function calcRunway() returns (uint) {
    return this.balance / salary;
  }

  function calcPayCount() returns(uint) {
    return ( now - lastPayday) /payPeriod;
  }

  function getSalary()  returns(uint){
    return  salary  / (1 ether);
  }

  function hasEnoughFund()  returns(bool){
    return this.balance >= calcPayCount() * salary ;
  }

  function updateEmployeeAddr(address addr)   {
    //TODO chekc addr valid
      if(msg.sender != employerAddr || addr  == employeeAddr) {
          revert();
      }
      employeeAddr = addr;
  }

  function updateSalary(uint newsalary)   {
      if(newsalary <= 0 ||msg.sender != employerAddr ) {
          revert();
      }
      getPay();
      salary = newsalary * (1 ether);
  }

  function getPay() returns(uint) {
    uint payCount = calcPayCount();
     if(payCount > 0) {
         uint totalsalary = salary * payCount;
         if(this.balance >= totalsalary) {
             lastPayday =lastPayday + payCount * payPeriod;
             employeeAddr.transfer(totalsalary );
             return this.balance;
         }
     }
     revert();
  }

}
