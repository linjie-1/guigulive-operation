pragma solidity ^0.4.14;
contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayDay = now;
    
    function Payroll() {
        owner = msg.sender;
        salary = 1 wei;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return caculateRunway() > 0;
    }

    /**
     * 支付以前拖欠的工资
     */
    function payLastSalary() {
        if (msg.sender != owner) {
            revert();
        }
        if (employee != 0x0) {
            //如果已经不够支付拖欠的工资，则无法继续执行
            uint payNum =  (now - lastPayDay) / payDuration;
            if (payNum > caculateRunway()) {
                revert();
            }

            uint payment = salary * payNum;
            employee.transfer(payment);
        }
        lastPayDay = now;
    }

    function setEmployee(address e) {
        payLastSalary();
        employee = e;
    }
    
    function setSalary(uint s) {
        payLastSalary();
        salary = s * 1 finney;
    }
    
    function updateEmployeeAndSalary(address e, uint s) {
        payLastSalary();
        employee = e;
        salary = s * 1 finney;
    }
    
    function getPaid() {
        if (msg.sender != employee) {
            revert();
        } 
        uint nextPayDay = lastPayDay + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
}