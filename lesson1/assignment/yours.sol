/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    address owner;
        
    function Payroll() { 
        owner = msg.sender; 
    } 
    
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
    
     function updateEmployee(address e, uint s) { 
        
        employee = e; 
        salary = s * 1 ether; 
        lastPayday = now; 
    } 
    
    function SetAddr(address _newAddr){
        require(msg.sender == owner); 
        if (employee != 0x0) { 
            uint payment = salary * (now - lastPayday) / payDuration; 
            employee.transfer(payment); 
        } 
        employee = _newAddr;
        lastPayday = now;
    }
    
    function ChangeSalary(uint _newSalary){
        require(msg.sender == owner); 
        salary = _newSalary * 1 ether; 
        /*改变薪水不需要立即支付工资,这也是一种合理的场景，老板临时提高工资来鼓励员工*/
    }
}
