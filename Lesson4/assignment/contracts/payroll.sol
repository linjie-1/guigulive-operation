pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    mapping(address => Employee) public employees;

    address owner;
    uint totalSalary = 0 * 1 ether;
    
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
        require(employee.id != 0x0);
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint s) onlyOwner employeeNotExist(employeeId) public{ 
        employees[employeeId] = Employee(employeeId, s * 1 ether, now);
        totalSalary = totalSalary.add(s * 1 ether);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public{
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint s) onlyOwner employeeExist(employeeId) public{
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        totalSalary = totalSalary.sub(employee.salary);
        employees[employeeId].salary = s * 1 ether;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(s * 1 ether);
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    
    function getPaid() employeeExist(msg.sender) public {

        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);        
    }
    
    function changePaymentAddress(address employeeId) employeeExist(msg.sender) employeeNotExist(employeeId) public {
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }
}
