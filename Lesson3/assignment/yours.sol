pragma solidity ^0.4.14;

import './Ownable.sol';

contract Payroll is Ownable {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    mapping(address => Employee) employees;
    uint total;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist(address id) {
        assert(employees[id].id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address id) {
        assert(employees[id].id == 0x0);
        _;
    }

    function addEmployee(address id, uint s) onlyOwner employeeNotExist(id) {
        employees[id] = Employee(id, s * 1 ether, now);
        total += s * 1 ether;
    }
    
    function removeEmployee(address id) onlyOwner employeeExist(id) {
        payRemainingSalary(id);
        total -= employees[id].salary;
        delete employees[id];
    }

    function updateEmployee(address id, uint s) onlyOwner employeeExist(id) {
        payRemainingSalary(id);

        Employee e = employees[id];
        total = total - e.salary + s * 1 ether;
        e.salary = s * 1 ether;
        e.lastPayday = now;
    }
    
    function addFund() onlyOwner payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / total;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        Employee e = employees[msg.sender];

        uint nextPayday = e.lastPayday + payDuration;
        assert(nextPayday < now);

        e.lastPayday = nextPayday;
        
        e.id.transfer(e.salary);
    }
    
    function payRemainingSalary(address id) onlyOwner employeeExist(id) {
        Employee e = employees[id];

        uint payment = e.salary * (now - e.lastPayday) / payDuration;
        if (payment > 0) {
            e.lastPayday = now;
            e.id.transfer(payment);
        }
    }

    function changePaymentAddress(address id) employeeExist(msg.sender) {
        Employee e = employees[msg.sender];
        employees[id] = Employee(id, e.salary, e.lastPayday);
        delete employees[msg.sender];
    }    
}
