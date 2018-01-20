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
    mapping(address => Employee) employees;
    uint totalSalary = 0;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        employee.id.transfer(employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration));
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier checkMsgSender(address employeeId) {
        if (employees[msg.sender].id != 0x0) {
            _;
        }
        require(msg.sender == owner || employees[msg.sender].id != 0x0);
        var employee = msg.sender == owner ? employees[employeeId] : employees[msg.sender];
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employee.id];
    }

    function getOwner() returns(address) {
        return owner;
    }

    function getSalary(address employeeId) returns(uint) {
        return employees[employeeId].salary;
    }

    function hasEmployee(address employeeId) returns(bool) {
        return employees[employeeId].id != 0x0;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(salary.mul(1 ether).sub(employee.salary));
        employee.salary = salary.mul(1 ether);
    }

    // function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
    //     var employee = employees[employeeId];
    //     delete employees[employeeId];
    //     totalSalary = totalSalary.sub(employee.salary);
    // }

    // function changePaymentAddress(address employeeId) employeeExists(msg.sender) {
    //     require(employeeId != msg.sender);
    //     var employee = employees[msg.sender];
    //     employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
    //     delete employees[msg.sender];
    // }

    /**
     *  利用 checkMsgSender 这个 modifier 整合 removeEmployee 和 changePaymentAddress 这两个函数
     *  如果是 owner 调用 changePaymentAddress，则实际实现的是 remove employee 的功能
     *  如果是一个 existing 的 employee 调用，则实际实现的是 change payment address
     *  不利用 modifier 整合的两个函数为上面两个分开的被注释掉的函数
    */
    function changePaymentAddress(address employeeId) checkMsgSender(employeeId) {
        require(employeeId != msg.sender);  // has to be a new address
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        totalSalary = totalSalary.add(employee.salary);
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        assert(totalSalary > 0);
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return totalSalary == 0 || calculateRunway() > 0;
    }

    function getPaid() employeeExists(msg.sender) {
        var employee = employees[msg.sender];
        uint timeToPay = employee.lastPayday.add(payDuration);
        if (timeToPay > now) {
            revert();
        }
        employee.lastPayday = timeToPay;
        // totalSalary = totalSalary.sub(employee.salary); // depends on how do we define calculateRunway
        employee.id.transfer(employee.salary);
    }
}