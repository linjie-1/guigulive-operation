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

    uint public totalSalary = 0;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public {
        var e = employees[employeeId];
        assert(e.id == 0x0);

        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var e = employees[employeeId];

        _partialPaid(e);
        totalSalary -= e.salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var e = employees[employeeId];

        _partialPaid(e);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;

    }
    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) public {
        var e = employees[msg.sender];

        uint nextPayDay = e.lastPayday + payDuration;
        assert(nextPayDay < now);

        employees[msg.sender].lastPayday = nextPayDay;
        employees[msg.sender].id.transfer(e.salary);
    }

    function changePaymentAddress(address employeeId, address newAddress) onlyOwner employeeExist(employeeId) public {
        var salary = employees[employeeId].salary;
        removeEmployee(employeeId);
        addEmployee(newAddress, salary / 1 ether);
    }

}
