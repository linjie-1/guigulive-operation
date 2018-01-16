pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 10 seconds;

    uint totalSalary;
    mapping(address => Employee) public employees;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayDay)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint _salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        uint salary  = _salary.mul(1 ether);
        employees[employeeId] = Employee({id: employeeId, salary: salary, lastPayDay: now});
        totalSalary           = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
       var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function updateSalary(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee   = employees[employeeId];
        uint newSalary = salary.mul(1 ether);
        assert(newSalary != employee.salary);

        _partialPaid(employee);
        totalSalary         = totalSalary.sub(employee.salary).add(newSalary);
        employee.salary     = newSalary;
        employee.lastPayDay = now;
    }

    function changePaymentAddress(address employeeNewId) employeeExist(msg.sender) employeeNotExist(employeeNewId) {
        var employee = employees[msg.sender];
        employees[employeeNewId] = Employee({id: employeeNewId, salary: employee.salary, lastPayDay: employee.lastPayDay});
        delete employees[msg.sender];
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) {
        var employee    = employees[msg.sender];
        uint nextPayDay = employee.lastPayDay.add(payDuration);
        assert(nextPayDay < now);

        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
