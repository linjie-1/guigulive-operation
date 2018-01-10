/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    
    uint salary;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint){
          return this.balance ;
    }
    function initEmployee(address a,uint s){
        employee=a;
        salary=s;
    }
    
    function Pay(){
        check();
        uint nextPayday =lastPayday +payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
        finaly();
    }
    function check(){
        if(salary ==0||employee==0x0000000000000000000000000000000000000000||msg.sender!=employee){
            revert();
        }
    }
    function finaly(){
        salary=0;
        employee=0x0000000000000000000000000000000000000000;
    }
}
  
