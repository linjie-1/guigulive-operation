pragma solidity ^0.4.19;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    address empolyee;
    uint salary;
    uint lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (salary == 0) {
            revert();
        }
        
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function setEmpolyee(address newEmpolyee) {
        // 修改者如果不是老板，或者新员工未设置，或者员工未发生改变，则不进行处理
        if (msg.sender != owner || newEmpolyee == 0x0 || empolyee == newEmpolyee) {
            revert();
        }
        
        empolyee = newEmpolyee;
    }
    
    function setSalary(uint newSalary) {
        // 修改者如果不是老板，或者工资未发生改变，则不进行处理
        if (msg.sender != owner || salary == newSalary) {
            revert();
        }
        
        // 结算工资变化前尚未支付的工资
        if (empolyee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            empolyee.transfer(payment);
        }
        
        salary = newSalary * 1 ether;
        lastPayday = now;
    }
    
    function getPaid() returns (uint) {
        if (msg.sender != empolyee) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        empolyee.transfer(salary);
    }
}
