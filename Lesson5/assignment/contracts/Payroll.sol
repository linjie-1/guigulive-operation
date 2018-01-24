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
    uint totalSalary;
    uint totalEmployees;
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
    
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId) {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        totalEmployees = totalEmployees.add(1);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        totalEmployees = totalEmployees.sub(1);
    }
    
    function employeeChangePaymentAddress(address newEmployeeId) public employeeExist(msg.sender) employeeNotExist(newEmployeeId) {
        employees[msg.sender].id = newEmployeeId;
    }
    
    function ownerUpdateEmployee(address employeeId, uint newSalary) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = newSalary.mul(1 ether);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    function addMoney() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        assert(totalSalary != 0);
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughMoney() public view returns (bool) {
        return calculateRunway() > 1;
    }
    
    function employeeGetPaid() public employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint shouldPayday = employee.lastPayday.add(payDuration);
        assert(shouldPayday < now);
        
        employees[msg.sender].lastPayday = shouldPayday;
        employee.id.transfer(employee.salary);
    }

    function checkInfo() public view returns (uint balance, uint runwayNumber, uint employeesCount) {
        balance = this.balance;
        employeesCount = totalEmployees;
        if (totalSalary > 0) {
            runwayNumber = calculateRunway();
        }
    }
}