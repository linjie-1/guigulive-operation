pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary;


    mapping(address=>Employee) public employees;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNonexist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }


    //增
    function addEmployee(address employeeId, uint etherSalary) onlyOwner employeeNonexist(employeeId) {
        employees[employeeId] = Employee(employeeId, etherSalary * 1 ether, now);
        totalSalary = totalSalary.add(etherSalary * 1 ether);
    }


    //删
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    //改员工薪水
    function updateEmployeeSalary(address employeeId, uint etherSalary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = etherSalary * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary.add(etherSalary * 1 ether);
    }

    //改员工地址
    function changePaymentAddress(address employeeIdOld , address employeeIdNew) onlyOwner employeeExist(employeeIdOld) employeeNonexist(employeeIdNew){
        var employee = employees[employeeIdOld];
        _partialPaid(employee);
        employee.id = employeeIdNew;
        employee.lastPayday = now;
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

    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}