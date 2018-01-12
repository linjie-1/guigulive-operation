pragma solidity ^0.4.14;

contract Payroll {
    // 与C语言类似，可以支持结构类型
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees; // 动态数组

    // 构造函数
    function Payroll() {
        owner = msg.sender;
    }
    
    // 知识点：private
    function _partialPaid(Employee employee) private {
    }
    
    // 查
    function _findEmployee(address employeeId) private returns (Employee, uint) {
    }

    // 增A
    function addEmployee(address employeeId, uint salary) {
    }
    
    // 删D
    function removeEmployee(address employeeId) {
    }
    
    // 改U
    function updateEmployee(address employeeId, uint salary) {
    }
    
    // 给合约账户里增加资金
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // 还能支付几次薪水？
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
    }
}
