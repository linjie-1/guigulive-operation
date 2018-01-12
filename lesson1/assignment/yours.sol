pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    address employee;
    uint salary;
    uint lastPayDay;

    function Payroll() {
        owner = msg.sender;
    }

    function updateEmployee(address newEmployee) returns (address) {
        require(msg.sender == owner);

        if (employee != newEmployee) {
            employee = newEmployee;
            lastPayDay = now;
        }

        return employee;
    }

    function updateSalary(uint newSalary) returns (uint) {
        require(msg.sender == employee);
        
        if (salary == newSalary) {
            return salary;
        }
        
        // Pay out salary owed to date
        uint salaryToPay = salary * (now - lastPayDay) / payDuration;
        require(this.balance >= salaryToPay);
        
        lastPayDay = now;
        employee.transfer(salaryToPay);
        
        // Update new salary
        salary = newSalary * 1 ether;

        return salary;
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
        require(hasEnoughFund());

        uint newPayDay = lastPayDay + payDuration;
        require(newPayDay < now);

        lastPayDay = newPayDay;
        employee.transfer(salary);
    }
}
