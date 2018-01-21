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
    
    modifier employeeExist (address employeeId) {
        var employee  = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    mapping(address => Employee) public employees;
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        return (employee.salary, employee.lastPayday);
    }
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee  = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary = totalSalary.add(salary * 1 ether);
        return;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];

        return;
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        return;
    }
    
    function changePaymentAddress(address oldEmployeeAddress, address newEmployeeAddress) onlyOwner employeeExist(oldEmployeeAddress) {
        var employee = employees[oldEmployeeAddress];
        assert(newEmployeeAddress != 0x0);
        employees[newEmployeeAddress] = employee;
        delete employees[oldEmployeeAddress];
        return;
    }
    
    function addFund() payable returns (uint) {
        return this.balance; 
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        _partialPaid(employee);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
