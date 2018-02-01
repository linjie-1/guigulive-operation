pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint index;
        uint salary;
        uint lastPayday;
    }

    event NewEmployee();
    event UpdateEmployee();
    event RemoveEmployee();
    event NewFund(uint fund);
    event GetPaid(uint amount);

    uint constant payDuration = 10 seconds;

    uint totalSalary;
    uint totalEmployee;
    address[] employeeList;
    mapping(address => Employee) public employees;


    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * ((now - employee.lastPayday) / payDuration);
        if (payment > 0)
            employee.id.transfer(payment);
    }

    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);

        employees[employeeId] = Employee(employeeId, employeeList.length, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
        NewEmployee();
    }

    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];
        uint index = employee.index;
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        employeeList[index] = employeeList[employeeList.length-1];
        employeeList.length--;
        totalEmployee = totalEmployee.sub(1);
        RemoveEmployee();
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
        UpdateEmployee();
    }

    function addFund() payable returns (uint) {
        NewFund(msg.value);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExists(msg.sender) {
        var employee = employees[msg.sender];
        uint payTimes = now.sub(employee.lastPayday).div(payDuration);
        uint amount = employee.salary * payTimes;
        uint nextPayday = employee.lastPayday.add(payDuration*payTimes);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(amount);
        GetPaid(amount);
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }
}
