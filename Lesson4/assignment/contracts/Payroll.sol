pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable{
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    using SafeMath for uint;
    uint constant payDuration = 10 seconds;

    uint totalSalary;
    mapping(address => Employee) employees;
    
    modifier addressExisted(address addressId) {
        require(addressId != 0x0);
        require(employees[addressId].id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        employee.id.transfer(employee.salary * (now.sub(employee.lastPayday)).div(payDuration));
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        require(employeeId != 0x0);
        Employee emp = employees[employeeId];
        require(emp.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }
    
    function removeEmployee(address employeeId) onlyOwner addressExisted(employeeId) {
        Employee emp = employees[employeeId];
        _partialPaid(emp);
        totalSalary = totalSalary.sub(emp.salary);
        delete employees[employeeId];
    }
    
    function changePaymentAddress(address old, address nnew) onlyOwner addressExisted(old){
        Employee emp = employees[old];
        _partialPaid(emp);
        employees[nnew] = Employee(nnew, emp.salary, now);
        delete employees[old];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner addressExisted(employeeId) {
        Employee emp = employees[employeeId];
        _partialPaid(emp);
        totalSalary = totalSalary.sub(emp.salary);
        emp.salary = salary.mul(1 ether);
        emp.lastPayday = now;
        totalSalary = totalSalary.add(emp.salary);
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (totalSalary > 0) {
            return this.balance.div(totalSalary);
        }
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() addressExisted(msg.sender) {
        Employee emp = employees[msg.sender];
        if (this.balance > emp.salary && now > emp.lastPayday.add(payDuration)) {
            emp.lastPayday = now;
            emp.id.transfer(emp.salary);
        }
    }
}
