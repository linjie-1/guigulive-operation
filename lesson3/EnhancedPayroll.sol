pragma solidity ^0.4.0;

import './lib/SafeMath.sol';
import './lib/Ownable.sol';

contract EnhancedPayroll is Ownable{
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salaryInMonth;
        uint lastPayDay;
    }
    mapping(address => Employee) public employees;
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    
    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint value = employee.salaryInMonth
                        .mul(now.sub(employee.lastPayDay))
                        .div(payDuration);
        employee.id.transfer(value);
    }
    
    // add
    function addEmployee(address id, uint salary) onlyOwner {
        var employee = employees[id];
        assert(employee.id == 0x0);
        
        employees[id] = Employee(id, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[id].salaryInMonth);
    }
    
    // remove
    function removeEmployee(address id) onlyOwner employeeExists(id) {
        var employee = employees[id];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salaryInMonth);
        delete employees[id];
    }
    
    // update 
    function updateEmployee(address id, uint salary) onlyOwner employeeExists(id) {
        var employee = employees[id];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[id].salaryInMonth);
        employees[id].salaryInMonth = salary;
        employees[id].lastPayDay = now;
        totalSalary = totalSalary.add(employees[id].salaryInMonth);
    }
    
    // addFund
    function addFund() payable returns (uint) {
        return this.balance;
    }

    // calculateRunway
    function calculateRunway() returns (uint) {
        assert(totalSalary > 0);
        return this.balance.div(totalSalary);
    }

    function hasEnoughMoney() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExists(msg.sender) {
        var employee = employees[msg.sender];
        
        uint shouldPayDay = employee.lastPayDay.add(payDuration);
        assert(shouldPayDay < now);

        employees[msg.sender].lastPayDay = shouldPayDay;
        employee.id.transfer(employee.salaryInMonth);
    }
    
    // changeAddress
    function changeEmployeeAddress(address id, address newId) onlyOwner employeeExists(id) {
        var employee = employees[id];
        
        var tmpEmployee = employees[newId];
        assert(tmpEmployee.id == 0x0);
        
        _partialPaid(employee);
        employees[newId] = Employee(newId, employee.salaryInMonth, now);
        delete employees[id];
    }
}
