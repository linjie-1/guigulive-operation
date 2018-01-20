pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    mapping(address => Employee) public employees;
    uint _totalSalary = 0;

    modifier employeeExist(address employeeAddr) {
        assert(employees[employeeAddr].addr != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeAddr){
        assert(employees[employeeAddr].addr == 0x0);
        _;
    }

    modifier destroyEmployee(address employeeAddr) {
        _;
        delete employees[employeeAddr];
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function caculateRunway() returns (uint) {
        return this.balance.div(_totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return caculateRunway() > 0;
    }

    function _partialPaid(Employee employee) private {
        //如果已经不够支付当前员工拖欠的工资，则无法继续执行
        uint payTimestamp = now.sub(employee.lastPayDay);
        assert(payTimestamp.div(payDuration) <= this.balance.div(employee.salary));

        uint payment = employee.salary.mul(payTimestamp).div(payDuration);
        employee.addr.transfer(payment);
    }

    function addEmployee(address employeeAddr, uint salary) onlyOwner {
        _totalSalary = salary.mul(1 finney).add(_totalSalary);

        employees[employeeAddr] = Employee(employeeAddr, salary.mul(1 finney), now);
    }

    function removeEmployee(address employeeAddr) onlyOwner employeeExist(employeeAddr) destroyEmployee(employeeAddr) {
        Employee employee = employees[employeeAddr];

        _partialPaid(employee);

        _totalSalary = _totalSalary.sub(employee.salary);
    }

    function updateEmployee(address employeeAddr, uint salary) onlyOwner employeeExist(employeeAddr) {
        Employee employee = employees[employeeAddr];

        _partialPaid(employee);

        _totalSalary = _totalSalary.sub(employee.salary).add(salary.mul(1 finney));

        employees[employeeAddr].salary = salary.mul(1 finney);
        employees[employeeAddr].lastPayDay = now;
    }

    function changePaymentAddress(address employeeAddr) employeeExist(msg.sender) employeeNotExist(employeeAddr) destroyEmployee(msg.sender) {
        Employee employee = employees[msg.sender];
        
        _partialPaid(employee);

        employees[employeeAddr] = Employee(employeeAddr, employee.salary, now);
    }
    
    function getPaid() employeeExist(msg.sender) {
        Employee employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayDay.add(payDuration);
        assert(nextPayDay < now);

        employees[msg.sender].lastPayDay = nextPayDay;
        employee.addr.transfer(employee.salary);
    }
}