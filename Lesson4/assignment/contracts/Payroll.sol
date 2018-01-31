pragma solidity ^0.4.14;

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
    
    uint public totalSalary = 0;
    
    modifier hasEmployee(address employeeId) {
    	assert(employees[employeeId].id != 0x0);
    	_;
    }

    function getBalance() public returns (uint) {
        return this.balance;
    }

    function getPayDuration() public returns (uint) {
        return payDuration;
    }

    function getNow() public returns (uint) {
        return now;
    }

    function employeeExists(address employeeId) public returns (bool) {
        return employees[employeeId].id != 0x0;
    }

    function _partialPaid(Employee employee) private {
    	uint salaryToPay = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(salaryToPay <= this.balance);
    	employee.id.transfer(salaryToPay * 1 ether);
    	employee.lastPayday = now;
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
    	assert(employees[employeeId].id == 0x0);
    	employees[employeeId] = Employee(employeeId, salary, now);
    	totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) public onlyOwner hasEmployee(employeeId) {
    	Employee storage employee = employees[employeeId];
    	uint salaryToPay = employee.salary * (now - employee.lastPayday) / payDuration;
        _partialPaid(employee);
		totalSalary -= employee.salary;
		delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner hasEmployee(employeeId) {
    	Employee storage employee = employees[employeeId];
    	_partialPaid(employee);
    	totalSalary += salary;
    	totalSalary -= employee.salary;
    	employee.salary = salary;
    }
    
    function addFund() payable public returns (uint) {
    	return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
    	return calculateRunway() > 0;
    }
    
    function getPaid() public hasEmployee(msg.sender) {
		_partialPaid(employees[msg.sender]);
    }
    
    function changePaymentAddress(address oldAddr, address newAddr) public onlyOwner hasEmployee(oldAddr) {
        uint salary = employees[oldAddr].salary;
        removeEmployee(oldAddr);
        addEmployee(newAddr, salary);
    }
}
