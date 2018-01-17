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

    /************** Tests ********************/
    function setUpEmployees() {
        addEmployee(0x14723a09acff6d2a60dcdf7aa4aff308fddc160c, 1);
        addEmployee(0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db, 1);
        addEmployee(0x583031d1113ad414f02576bd6afabfb302140225, 1);
    }

    function testAddEmployee() {
        assert(employees[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c].id == 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c);
        assert(employees[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c].salary == 1 ether);
        assert(employees[0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db].id == 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db);
        assert(employees[0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db].salary == 1 ether);
        assert(employees[0x583031d1113ad414f02576bd6afabfb302140225].id == 0x583031d1113ad414f02576bd6afabfb302140225);
        assert(employees[0x583031d1113ad414f02576bd6afabfb302140225].salary == 1 ether);
        assert(totalSalary == 3 ether);
    }

    // Run this function using account 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
    function testGetPaid() {
        uint balanceBefore = employees[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c].id.balance;
        getPaid();
        assert(employees[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c].id.balance.sub(balanceBefore) == 1 ether);
    }

    // Run this function using owner account
    function testRemoveEmployee() {
        changePaymentAddress(0x14723a09acff6d2a60dcdf7aa4aff308fddc160c);
        assert(employees[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c].id == 0x0);
        assert(totalSalary == 2 ether);
    }

    // Run this function using account 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db
    function testChangePaymentAddress() {
        changePaymentAddress(0xca35b7d915458ef540ade6068dfe2f44e8fa733c);
        assert(employees[0xca35b7d915458ef540ade6068dfe2f44e8fa733c].id == 0xca35b7d915458ef540ade6068dfe2f44e8fa733c);
        assert(totalSalary == 2 ether);
    }

    // Run this function using owner account
    function testUpdateEmployee() {
        var employee = employees[0xca35b7d915458ef540ade6068dfe2f44e8fa733c];
        uint oldLastPayDay = employee.lastPayday;
        uint oldSalary = employee.salary;
        uint oldBalance = employee.id.balance;
        updateEmployee(employee.id, 2);
        assert(employee.salary == 2 ether);
        assert(employee.id.balance.sub(oldBalance) == oldSalary.mul(employee.lastPayday.sub(oldLastPayDay)).div(payDuration));
        assert(totalSalary == 3 ether);
    }
}