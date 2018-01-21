pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address=>Employee) public employees;
    uint totalSalary;

    modifier employeeExists(address employeeId){
        var employee = employees[employeeId];
        require(employee.lastPayday != 0);
        _;
    }

    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        require(employee.lastPayday == 0);
        _;
    }
    
    function checkEmployeeExists(address employeeId) public returns (bool){
        var employee = employees[employeeId];
        return employee.lastPayday != 0 ;
    }

    function _partialPaid(address employeeId, Employee employee) private returns (uint) {

        uint paySalary = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        
        require(this.balance >= paySalary.mul(1 ether));
        employeeId.transfer(paySalary.mul(1 ether));
        employee.lastPayday = now;
        return paySalary;
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId) {
        totalSalary = totalSalary.add(salary);
        employees[employeeId] = Employee(salary, now);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExists(employeeId) {

        

        assert(totalSalary >= employees[employeeId].salary);
        totalSalary = totalSalary.sub(employees[employeeId].salary);

        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExists(employeeId) returns (uint, uint) {


        var employee = employees[employeeId];
        uint partialSalary = _partialPaid(employeeId, employee);

        assert(totalSalary >= employee.salary);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary;
        totalSalary = totalSalary.add(salary);

        //monitor partial salary (in ethers)
        //monitor balance (in ethers)
        return (partialSalary, this.balance/1 ether); 
    }
    
    function addFund() payable public returns (uint) {

        return this.balance;

    }
    
    function calculateRunway() public returns (uint) {

        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() employeeExists(msg.sender) public {

        var employee = employees[msg.sender];
        require(this.balance >= employee.salary.mul(1 ether));
        employee.lastPayday = employee.lastPayday.add(payDuration);
        msg.sender.transfer(employee.salary.mul(1 ether));

    }

    //员工角度
    function changePaymentAddress(address newEmployeeId) public employeeExists(msg.sender) employeeNotExist(newEmployeeId) {
        employees[newEmployeeId] = employees[msg.sender];
        delete employees[msg.sender];
    }
}
