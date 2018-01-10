pragma solidity ^0.4.14;
contract Payroll  {
    
    uint  salary = 1 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address Boss = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    
    //Boss update the salary (only need input Ether amount！！！)
    function updateSalary(uint _salary) returns (uint)  {
       
      if(msg.sender != Boss){
          revert();
      }
       
      salary = _salary*1 ether;
         
       return _salary;
   }
   
   // staff update his salary account
   function updateSalaryAccount(address _frank) returns (address){
       
         if(msg.sender !=frank || _frank == Boss){
          revert();
      }
       
      frank = _frank ;
      
      return frank;
       
   }
   // add fund into the account
    function addFund() payable returns(uint) {
          
        return  this.balance;
    }
    
    // display the current account balance
    function showAccount() returns (uint) {
        
        return  this.balance;
        
    }
    
    // display the current staff salary
    function showSalary() returns (uint) {
        
        return  salary;
        
    }
    
    //calculate how many times can afford for the staff salary
    function calculateRunway() returns (uint){
        
        return this.balance/salary;
    }
  
    //calculate if has enough fund
    function hasEnoughFund() returns (bool){
        
        return  calculateRunway()> 0;
        
    }
  
    // the staff claim his salary
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
