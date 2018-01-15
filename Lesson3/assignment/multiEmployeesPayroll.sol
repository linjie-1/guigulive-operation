//  各个函数执行的结果记录见 ./executionRecord.md

/**  
 * 增加 employeeChangePaymentAddress 的思路：
 * 1. 为了确保增加的新地址不存在于合约中，需要先确认这种特殊情况，于是参考 employeeExist函数，利用 modifier 增加 employeeNotExist 函数。
 * 2. 这个函数也可以放进 addEmployee 函数中，确保增加的地址不存在于合约中 
**/

pragma solidity ^0.4.14;

import './safeMath.sol';
import './ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    address owner;
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
        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(payDuration);
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function employeeChangePaymentAddress(address newEmployeeId)  employeeExist(msg.sender) employeeNotExist(newEmployeeId) {
        employees[msg.sender].id = newEmployeeId;
    }
    
    function ownerUpdateEmployee(address employeeId, uint newSalary)  onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = newSalary.mul(1 ether);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    function addMoney() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        assert(totalSalary != 0);
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughMoney() returns (bool) {
        return calculateRunway() > 1;
    }
    
    function employeeGetPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint shouldPayday = employee.lastPayday.add(payDuration);
        assert(shouldPayday < now);
        
        employees[msg.sender].lastPayday = shouldPayday;
        employee.id.transfer(employee.salary);
    }
}