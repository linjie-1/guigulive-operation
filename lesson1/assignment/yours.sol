pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
        employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c; // 写死了第二个测试地址
        salary = 1 wei;
        lastPayday = now;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 wei;  //我把单位全用wei了，更方便测试了，否则在测试的时候，每个数后面一堆0，直接数不清
        lastPayday = now;
    }
    
    function updateAddress(address e) {
        require(employee != e) ;
        updateEmployee(e, salary);
    }
    
    function updateSalary(uint s)
    {
        require(salary != s * 1 wei);
        updateEmployee(employee, s);
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
