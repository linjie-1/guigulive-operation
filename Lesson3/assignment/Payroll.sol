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

    uint constant _payDuration = 10 seconds;

    uint _totalSalary = 0;
    mapping(address => Employee) public employees;

    modifier _employeeExist(address employeeId) {
       var employee = employees[employeeId];
       assert(employee.id != 0x0);
       _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(_payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint newSalary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, newSalary, now);
        _totalSalary = _totalSalary.add(newSalary);
    }

    function removeEmployee(address employeeId) onlyOwner _employeeExist(employeeId) {
       var employee = employees[employeeId];
       _partialPaid(employee);
       _totalSalary = _totalSalary.sub(employee.salary);
       delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner _employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        _totalSalary = _totalSalary.sub(employee.salary);
        uint newSalary = salary.mul(1 ether);
        _totalSalary = _totalSalary.add(newSalary);
        employees[employeeId].salary = newSalary;
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(_totalSalary);
    }

    function hasEnoughFund() returns (bool) {
         return calculateRunway() > 0;
    }

    function getPaid() _employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.sub(_payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }

    function changePaymentAddress(address employeeId, address NewAddress) onlyOwner _employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        employee.id = NewAddress;
    }


}