pragma solidity ^0.4.14;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Payroll is Ownable {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
        
    }
    uint constant payDuration = 10 seconds;
    
    mapping(address => Employee) public employees;
    uint totalSalary;
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = SafeMath.div(SafeMath.mul(employee.salary, SafeMath.sub(now, employee.lastPayday)), payDuration);
        employee.id.transfer(payment);
    }
    
    function changePaymentAddress(address newEmployeeId) employeeExist(msg.sender){
        employees[msg.sender].id = newEmployeeId;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addEmployee(address employeeId, uint numOfEthers) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint salary = SafeMath.mul(numOfEthers, 1 ether);
        totalSalary = SafeMath.add(totalSalary, salary);
        
        employees[employeeId] = Employee(employeeId, salary, now);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);

        totalSalary = SafeMath.sub(totalSalary, employee.salary);
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint numOfEthers) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary = SafeMath.sub(totalSalary, employee.salary);
        _partialPaid(employee);
        employee.salary = SafeMath.mul(numOfEthers, 1 ether);
        totalSalary = SafeMath.add(totalSalary, employee.salary);
        employee.lastPayday = now;
    }
    
    function addFund() public onlyOwner payable returns (uint)  {
        return this.balance;
    }
    
    function getPayDuration() returns (uint) {
        return payDuration;
    }
    
    function calculateRunway() returns (uint) {
        return SafeMath.div(this.balance, totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; // In EVM it's jump operation; if use this.calculateRunway() will use msg, gas cost is high 
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = SafeMath.add(employee.lastPayday, payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
