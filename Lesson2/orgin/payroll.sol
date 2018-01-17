pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
    }

    function addEmployee(address employeeId, uint salary) {
    }
    
    function removeEmployee(address employeeId) {
    }
    
    function updateEmployee(address employeeId, uint salary) {
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunAway() >= 1;
    }
    
    function getPaid() {

        uint nextPayDay = lastPayDay + payDuration;
        
        require(msg.sender == employee && nextPayDay<=now );

        uint salaryTmp = salary*((now-lastPayDay)/payDuration);
        lastPayDay = now;
        employee.transfer(salaryTmp);// allow get paid after several duration
    }
}
