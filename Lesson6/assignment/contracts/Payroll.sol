pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    event NewFund(uint amount);
    event GetPaid(address employeeId, uint salary);
    event NewEmployee(address employeeId, uint salary);
    event UpdateEmployee(address employeeId, uint salary);
    event RemoveEmployee(address employeeId);

    uint constant payDuration = 10 seconds;

    uint totalSalary;
    uint totalEmployee;
    address[] employeeList;
    mapping(address => Employee) public employees;


    modifier employeeExit(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint timestamp = now;
        if (timestamp >= employee.lastPayday) {
            uint payment = employee.salary
                .mul(timestamp.sub(employee.lastPayday))
                .div(payDuration);
            employee.id.transfer(payment);
        }

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

        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);
        NewEmployee(employeeId, salary);
    }
    
    function removeEmployee(uint employeeIndex) onlyOwner employeeExit(employeeList[employeeIndex]) {
        address employeeId = employeeList[employeeIndex];
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        totalEmployee = totalEmployee.sub(1);
        employeeList[employeeIndex] = employeeList[totalEmployee];
        delete employees[employeeId];
        delete employeeList[totalEmployee];
        employeeList.length = employeeList.length.sub(1);
        RemoveEmployee(employeeId);
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
        UpdateEmployee(employeeId, salary);
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
        GetPaid(msg.sender, employee.salary);
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }

    function getPayDuration() returns (uint) {
        return payDuration;
    }
}
