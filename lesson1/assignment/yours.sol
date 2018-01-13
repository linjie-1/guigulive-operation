pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            payRemainingSalary();
        }
        
        employee = e;
        lastPayday = now;
    }
    
    function updateSalary(uint s){
        require(msg.sender == owner);
        
        salary = s * 1 ether;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
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
        assert(nextPayday < now);

        lastPayday = nextPayday;
        
        uint payment = salary;
        if (this.balance < payment) {
            payment = this.balance;
        }        
        employee.transfer(payment);
    }
    
    function payRemainingSalary(){
        require(msg.sender == owner);
        require(employee != 0x0);

        uint payment = salary * (now - lastPayday) / payDuration;
        if (payment > 0) {
            if (this.balance < payment) {
                payment = this.balance;
            }
            lastPayday = now;
            employee.transfer(payment);
        }
    }
}


