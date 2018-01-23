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
    uint payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) public employees;

    uint totalSalary = 0;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var e = employees[employeeId];
        assert(e.id == 0x0);

        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var e = employees[employeeId];

        _partialPaid(e);
        totalSalary -= e.salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var e = employees[employeeId];

        _partialPaid(e);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;

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
        var e = employees[msg.sender];

        uint nextPayDay = employees[msg.sender].lastPayday + payDuration;
        assert(nextPayDay < now);

        employees[msg.sender].lastPayday = nextPayDay;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }

    function changePaymentAddress(address employeeId, address newAddress) onlyOwner employeeExist(employeeId) {
        var salary = employees[employeeId].salary;
        removeEmployee(employeeId);
        addEmployee(newAddress, salary / 1 ether);
    }

}
