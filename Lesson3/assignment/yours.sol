pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address eAddress;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuratin = 10 seconds;
    mapping(address => Employee) public employees;
    uint totalSalary;

    modifier employeeExist(address eAddress) {
        var employee = employees[eAddress];
        assert(employee.eAddress != 0x0);
        _;
    }
    
    modifier employeeNotExist(address eAddress){
        var employee = employees[eAddress];
        assert(employee.eAddress == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuratin);
        employee.eAddress.transfer(payment);
    }
    
    function addEmployee(address eAddress,uint salary) onlyOwner employeeNotExist(eAddress) {
        var employee = employees[eAddress];
        uint _salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(_salary);
        employees[eAddress] = Employee(eAddress,_salary,now);
    }
    
    function removeEmployee(address eAddress) onlyOwner employeeExist(eAddress) {
        var employee = employees[eAddress];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[eAddress];
    }
    
    function updateEmployee(address eAddress,uint salary) onlyOwner employeeExist(eAddress) {
        var employee = employees[eAddress];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[eAddress].salary);
        employees[eAddress].salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employees[eAddress].salary);
        employees[eAddress].lastPayday = now;
    }
    
    function changePaymentAddress(address eNewAddress) employeeExist(msg.sender) employeeNotExist(eNewAddress) {
        var employee = employees[msg.sender];
        employees[eNewAddress] = Employee(eNewAddress,employee.salary,employee.lastPayday);
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
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuratin);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.eAddress.transfer(employee.salary);
    }
}
