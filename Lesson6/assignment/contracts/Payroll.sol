pragma solidity ^0.4.13;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    uint totalSalary;
    uint totalEmployee;
    mapping(address => Employee) public employees;

    address[] employeeList;

    event AddEmployee(address employee);
    event RemoveEmployee(address employee);
    event UpdateEmployee(address employee);
    event NewFund(uint balance);
    event GetPaid(address employee);

    modifier employeeExit(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);

        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
        AddEmployee(employeeId);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        totalEmployee = totalEmployee.sub(1);
        for (uint i = 0; i < employeeList.length; i++) {
            if (employeeList[i] == employeeId) {
                delete employeeList[i];
                employeeList[i] = employeeList[employeeList.length-1];
                employeeList.length -= 1;
                RemoveEmployee(employeeId);
                break;
            }
        }
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
        UpdateEmployee(employeeId);
    }

    function addFund() payable returns (uint) {
        NewFund(this.balance);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExit(msg.sender) {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        GetPaid(msg.sender);
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        if (totalSalary > 0) {
            runway = calculateRunway();
        } else {
            runway = 0;
        }
        balance = this.balance;
        employeeCount = totalEmployee;
    }

    function checkEmployee(uint index) returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
}
