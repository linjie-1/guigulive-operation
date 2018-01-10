pragma solidity ^0.4.14;

contract Payroll {
  uint salary = 1 ether  ;
  address employeeAddr = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c ;
  address employerAddr ;
  uint constant payPeriod = 10 seconds;
  uint lastPayday  = now;

  function Payroll() {
        employerAddr = msg.sender;
    }

  function addFund() payable returns(uint){
     return this.balance;
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

  function updateEmployeeAddr(address addr)  returns(bool)  {
    //TODO chekc addr valid
    require(msg.sender == employerAddr);
    employeeAddr = addr;
  }

  function updateSalary(uint newsalary)   {
    require(msg.sender == employerAddr);
    if(employeeAddr != 0x0) {
      uint payCount = calcPayCount();
      if(payCount > 0) {
        uint totalsalary = salary * payCount;
        require(this.balance >= totalsalary);
        lastPayday =lastPayday + payCount * payPeriod;
        employeeAddr.transfer(totalsalary );
      }
    }
    salary = newsalary * (1 ether);
  }

  function getPay() returns(uint) {
    require(msg.sender == employeeAddr);
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
