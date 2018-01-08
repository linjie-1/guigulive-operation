pragma solidity ^0.4.14;
contract Payroll  {
    
    uint  salary = 1 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address Boss = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
 
    //Boos调整salary
    function updateSalary()  {
       
       if(msg.sender != Boss){
           revert();
       }
       
       
   }
    function addFund() payable returns(uint) {
          
        return  this.balance;
    }
    
    function showAccount() returns (uint) {
        
        return  this.balance;
        
    }
    function calculateRunway() returns (uint){
        
        return this.balance/salary;
    }
  
    function hasEnoughFund() returns (bool){
        
        return  calculateRunway()> 0;
        
    }
  
   function getPaid() returns (uint) {
       
       if(msg.sender !=frank ){
           revert();
       }
       
       uint nextPayday = payDuration + lastPayday;
       if(nextPayday > now){
           revert();
       }
       
       lastPayday = nextPayday;
       frank.transfer(salary);
       return frank.balance;
       
       
   }
   

  
}
