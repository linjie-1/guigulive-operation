pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    address owner;

    mapping(address => Employee) public employees;

    uint totalSalary  = 0;
    

    modifier employeeExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    // 内部function, 用来解决避免重复写code
    // 此处要把内部函数设为private, 因为用到了在Payroll()中自定义的Employee
    function _partialPaid(Employee employee) private {
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
    }


    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        
    }


    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        _partialPaid(employees[employeeId]);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }


    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        
        _partialPaid(employees[employeeId]);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;

    }
    
    function changePaymentAddress(address employeeIdNew) employeeExist(msg.sender) {
        _partialPaid(employees[msg.sender]);
        var employee = employees[msg.sender];
        employees[employeeIdNew] = Employee(employeeIdNew, employee.salary, employee.lastPayday);
        delete employees[msg.sender];

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
    
    // 包含多人的合约的getpaid()
    function getPaid() employeeExist(msg.sender){
        
        uint nextPayday = employees[msg.sender].lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }

}