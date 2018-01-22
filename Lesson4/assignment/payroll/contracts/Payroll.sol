pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";


contract Payroll is Ownable {
    using SafeMath for uint;

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
    
    function _partialPaid(Employee employee) private {
            uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
            employee.id.transfer(payment);
    }


    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId) {
        totalSalary += salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        
    }


    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId){
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }


    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId){
        
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;

    }
    
    function changePaymentAddress(address employeeIdNew) public employeeExist(msg.sender) {
        _partialPaid(employees[msg.sender]);
        var employee = employees[msg.sender];
        employees[employeeIdNew] = Employee(employeeIdNew, employee.salary, employee.lastPayday);
        delete employees[msg.sender];

    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    // 包含多人的合约的getpaid()
    function getPaid() public employeeExist(msg.sender){
        
        uint nextPayday = employees[msg.sender].lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }

}