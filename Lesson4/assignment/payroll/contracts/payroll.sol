/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    mapping (address => Employee) public employees;
    uint totalSalary;


    modifier employeeNotExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    modifier employeeExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }


    function changePaymentAddress(address employeeId) employeeExist(msg.sender) employeeNotExist(employeeId) public {
        employees[employeeId] = Employee(employeeId, employees[msg.sender].salary, employees[msg.sender].lastPayday);
        delete employees[msg.sender];
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) public {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        Employee storage employee = employees[employeeId];
        _partialPay(employeeId);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function updateEmployee( address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        Employee storage employee = employees[employeeId];
        _partialPay(employeeId);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employee.salary);
    }

    function addFund() external payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() external view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) external {
        Employee storage employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }



    function _partialPay(address employeeId) private {
        Employee storage employee = employees[employeeId];
        uint workDuration = now.sub(employee.lastPayday);
        uint payment = employee.salary.mul(workDuration).div(payDuration);
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }
}

