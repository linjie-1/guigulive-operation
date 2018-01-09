pragma solidity ^0.4.0;

contract Payroll {
    address employer;
    address employee;
    uint salary;
    uint lastPayDate;
    uint constant payInterval = 10 seconds;

    function Payroll(address _employee, uint _salary) {
        employer = msg.sender;
        employee = _employee;
        salary = _salary * 1 ether;
        lastPayDate = now;
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
        uint timeToPay = lastPayDate + payInterval;
        if (timeToPay > now) {
            revert();
        }
        lastPayDate = timeToPay;
        employee.transfer(salary);
    }

    function updateEmployee(address e) {
        require(msg.sender == employer);
        employee = e;
    }

    function updateSalary(uint s) {
        require(msg.sender == employer);
        uint amountToPay = salary * (now - lastPayDate) / payInterval;
        lastPayDate = now;
        salary = s * 1 ether;
        employee.transfer(amountToPay);
    }

    function updateEmployeeAndSalary(address e, uint s) {
        updateSalary(s);
        updateEmployee(e);
    }

    /****************************Some tests*********************************/

    function testGetPaid() {
        address testEmployee = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
        uint balanceBefore = testEmployee.balance;
        getPaid();
        assert(testEmployee.balance - balanceBefore == 10 ether);
    }

    function testUpdateEmployee() {
        address newEmployeeAddr = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        updateEmployee(newEmployeeAddr);
        assert(employee == newEmployeeAddr);
    }

    function testUpdateSalary() {
        address testEmployee = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
        uint newSalary = 15;
        uint oldLastPayDate = lastPayDate;
        uint oldSalary = salary;
        uint oldBalance = testEmployee.balance;
        updateSalary(newSalary);
        assert(salary == 15 ether);
        assert(testEmployee.balance - oldBalance == oldSalary * (lastPayDate - oldLastPayDate) / payInterval);
    }
}