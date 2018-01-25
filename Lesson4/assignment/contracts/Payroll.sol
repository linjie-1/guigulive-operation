/*作业请提交在这个目录下*/
pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address employeeId;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    mapping(address => Employee) public employees;
    uint totalSalary;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.employeeId != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.employeeId == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.employeeId.transfer(payment);
    }
    
    function addEmployee(address employeeId,uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        uint _salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(_salary);
        employees[employeeId] = Employee(employeeId,_salary,now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address new_address) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employees[new_address] = Employee(new_address,employee.salary,employee.lastPayday);
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
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.employeeId.transfer(employee.salary);
    }
}
