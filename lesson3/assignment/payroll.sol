pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{
    
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    address owner;
    uint public totalSalary;
    uint constant payDuration = 10 seconds;

    mapping (address => Employee ) employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    modifier employeeExists(address employeeId){
        assert(employees[employeeId].id!=0x0);
        _;
    }
    modifier employeeNotExists(address employeeId){
        assert(employees[employeeId].id==0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = (employee.salary.mul(now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExists(oldAddress) employeeNotExists(newAddress) {
        var oldEmployee = employees[oldAddress];
        var newEmployee = Employee(newAddress, oldEmployee.salary, oldEmployee.lastPayday);
        delete employees[oldAddress];
        employees[newAddress] = newEmployee;
    }
    
    function addEmployee(address employeeId, uint salary__ether) onlyOwner employeeNotExists(employeeId) {
        employees[employeeId] = Employee(employeeId, salary__ether * 1 ether, now);
        totalSalary = totalSalary.add(salary__ether.mul(1 ether));
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary__ether) onlyOwner employeeExists(employeeId) {
        var employee = employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary).add(salary__ether.mul(1 ether));
        employee.id = employeeId;
        employee.salary = salary__ether.mul(1 ether);
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        require(totalSalary > 0);
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() employeeExists(msg.sender)  returns (bool) {
        return this.balance > employees[msg.sender].salary;
    }
    
    function getPaid() employeeExists(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday <= now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
    
