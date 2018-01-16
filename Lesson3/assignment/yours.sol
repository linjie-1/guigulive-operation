pragma solidity ^0.4.14;

import './SafeMath.sol';

contract Payroll {
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address=>Employee) public employees;
    uint totalSalary = 0;
    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
       var employee = employees[employeeId];
       //make sure employee is exist before remove
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
        
        //makesure employee is not exist before add
        assert(employee.id == 0x0);
        uint newSalary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId,newSalary,now);
        totalSalary = totalSalary.add(newSalary);
    }
    

    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
       var employee = employees[employeeId];
       _partialPaid(employee);
       totalSalary = totalSalary.sub(employee.salary);
       delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        uint newSalary = salary.mul(1 ether);
        totalSalary = totalSalary.add(newSalary);
        employees[employeeId].salary = newSalary;
        employees[employeeId].lastPayday = now;
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
        uint nextPayday = employee.lastPayday.sub(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
