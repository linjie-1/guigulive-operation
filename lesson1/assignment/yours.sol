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
    
        
    /* Add 2 functions */
    function myUpdateEmployee(address e) {
        // 1. make sure only owner can call this function, which means the balance coming from owner
        // 2. make sure if employee address is not null, pay last emoployee
        // 3. when pay last employee, make sure we have enough fund
        
        require(msg.sender == owner);
        if(employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            require(this.balance >= payment);
            employee.transfer(payment);
        }
        employee = e;
        lastPayday = now;
    }
    
    function myUpadteSalary(uint s) {
        require(msg.sender == owner);
        if(employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            require(this.balance >= payment);
            employee.transfer(payment);
        }        
        salary = s;
        lastPayday = now;
    }
    
    /* End */

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
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);

    }

}
