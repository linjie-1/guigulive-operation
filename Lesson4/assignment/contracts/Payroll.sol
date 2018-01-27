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
    uint constant payDuration = 10 seconds;
    address owner;
    uint totalSalary = 0;
    
    // mapping
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
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint s) onlyOwner employeeNotExist(employeeId) public {
        var employee = employees[employeeId];
        uint salary = s * 1 ether;
        employees[employeeId] = Employee(employeeId,salary,now);
        totalSalary = totalSalary.add(salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
    }
    
    function getEmployeeSalary(address employeeId) view public returns (uint) {
        return employees[employeeId].salary;
    }

    function addFund() payable onlyOwner public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() employeeExist(msg.sender) public returns (uint salary) {
        var employee = employees[msg.sender];
        return this.balance / totalSalary;
    }
    
    function getPaid() employeeExist(msg.sender) public {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employee.lastPayday = now;
        employee.id.transfer(employee.salary);
    }
}