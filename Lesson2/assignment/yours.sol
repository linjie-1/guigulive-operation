/*完成今天的智能合约添加100ETH到合约中

加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

如何优化calculateRunway这个函数来减少gas的消耗？ 提交：智能合约代码，gas变化的记录，calculateRunway函数的优化*/

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    
    uint totalSalary = 0;

    function Payroll () public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
    	uint salaryToPay = employee.salary * (now - employee.lastPayday) / payDuration;
    	employee.id.transfer(salaryToPay * 1 ether);
    	employee.lastPayday = now;
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
    	for (uint i = 0; i < employees.length; i++) {
    		if (employees[i].id == employeeId) {
    			return (employees[i], i);
    		}
    	}
    }

    function addEmployee(address employeeId, uint salary) public returns(uint){
    	require(msg.sender == owner);
    	var (employee, employeeIdInArray) = _findEmployee(employeeId);
    	assert(employee.id == 0x0);
    	employees.push(Employee(employeeId, salary, now));
    	totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) public {
    	require(msg.sender == owner);
    	var (employee, employeeIdInArray) = _findEmployee(employeeId);
    	assert(employee.id != 0x0);
		_partialPaid(employee);
		totalSalary -= employee.salary;
		delete employee;
		employees[employeeIdInArray] = employees[employees.length-1];
		employees.length = employees.length - 1;
    }
    
    function updateEmployee(address employeeId, uint salary) public {
    	require(msg.sender == owner);
    	var (employee, employeeIdInArray) = _findEmployee(employeeId);
    	assert(employee.id != 0x0);
    	_partialPaid(employee);
    	totalSalary += salary;
    	totalSalary -= employees[employeeIdInArray].salary;
    	employees[employeeIdInArray].salary = salary;
    }
    
    function addFund() payable public returns (uint) {
    	return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        require(employees.length > 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public returns (bool) {
    	return calculateRunway() > 0;
    }
    
    function getPaid() public{
    	require(owner == msg.sender);
    	for (uint i = 0; i < employees.length; i++) {
    		_partialPaid(employees[i]);
    	}
    }
}