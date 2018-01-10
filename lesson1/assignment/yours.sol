/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
uint constant payDuration =10 seconds;
address owner;
uint salary;
address employee;
unit lastPayday;
}

function Payroll() {
 owner = msg.sender;
 }
 funtion updateEmployee(address e, unit s) {
 require(msg.sender == owner);
 
 if（employee != 0x0)） {
  uint payment = salary * (now - lastPayday) / payDuration;
   employee.transfer(payment);
   }
   employee = e;
   salary = s* 1 ether;
   lastPayday= now;
   }
    funtion addFund() payable returns (uint) {
       return this.balance;
      }
     funtion calcuatateRunway() returns (uint) {
      returns this.balance / salary;
      }
      function hasEncoughFund() returns (boll) {
      return calulateRunway(）> 0;
      }
      function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPday;
        employee.transfer(salary);
        }
        
      
       
    
     
  
