/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunaway() returns(uint){
        return this.balance / salary;
    }
    
    function hasEnoughFound() returns (bool){
        return calculateRunaway() > 0;
    }
    
    function getPaid() {
        if(msg.sender != employee){
            revert();
        }
        uint nextPayDay =  lastPayday + payDuration;
        if(nextPayDay > now){
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
    
    function SetAddr(address _newAddr){
        employee = _newAddr;
    }
    
    function ChangeSalary(uint _newSalary){
        salary = _newSalary;
    }
}
