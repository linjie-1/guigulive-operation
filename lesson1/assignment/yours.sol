/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    

    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    address owner;
    uint salary = 1 ether;

    // 新加..
    function Payroll() {
        owner = msg.sender;
    }
    
    //设置地址和工资额+新增
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }

    // 设置地址
    function setAddress(address addr) {
        employee = addr;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function colculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function get() returns (uint)  {
        return this.balance;
    }

    function hasEnoughFund() returns (bool) {
        return colculateRunway() > 0;
    }
    // 
    function getPaid() {
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay < now) {
            lastPayday = nextPayDay;
            employee.transfer(salary);
        }
      
    }

}