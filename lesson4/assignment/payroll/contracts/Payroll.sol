pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{

    using SafeMath for uint;

    uint constant payDuration = 10 seconds;

    uint public totalSalary;

    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }

    mapping(address => Employee) public employees;

	modifier employeeExist(address e) {
		require(employees[e].id != 0x0);
		_;
	}

	modifier addressExist(address e) {
		require(e != 0x0);
		_;
	}

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address e, uint s) public onlyOwner{
        var employee = employees[e];
        // when no employee is found, does _findEmployee return empty values?
        assert(employee.id == 0x0);
        uint salary = s.mul(1 ether);
        employees[e] = Employee(e, salary, now);
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address e) public onlyOwner employeeExist(e){
        var employee = employees[e];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[e];
    }

    function updateEmployee(address e, uint s) public onlyOwner employeeExist(e){
        var employee = employees[e];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = s.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint){
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender){
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function changePaymentAddress(address oldAdd, address newAdd) public
                onlyOwner employeeExist(oldAdd) addressExist(newAdd){
        var employee = employees[oldAdd];
        _partialPaid(employee);
        var newEmployee = Employee(newAdd, employee.salary, now);
        delete employees[oldAdd];
        employees[newAdd] = newEmployee;
    }
}
