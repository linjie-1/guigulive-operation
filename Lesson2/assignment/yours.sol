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

    function Payroll() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
    	require(msg.sender == owner);
    	_;
    }
    
    function _partialPaid(Employee employee) private {
    	uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    	employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
    	for(uint i=0; i<employees.length; i++){
    		if(employees[i].id == employeeId){
    			return (employees[i], i);
    		}
    	}
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
    	// If the employee exist, return
    	var (employee, index) = _findEmployee(employeeId);
    	assert(employee.id == 0x0);

    	employees.push(Employee(employeeId, salary * 1 ether, now));

    }
    
    function removeEmployee(address employeeId) public onlyOwner {
    	var (employee, index) = _findEmployee(employeeId);
    	assert(employee.id != 0x0);
    	_partialPaid(employee);

    	delete employees[index];
    	employees[index] = employees[employees.length-1];
    	employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner {
    	var (employee, index) = _findEmployee(employeeId);
    	assert(employee.id != 0x0);
    	_partialPaid(employee);

    	employees[index].salary = salary * 1 ether;
    	employees[index].lastPayday = now;

    }
    
    function addFund() payable public returns (uint) {
    }
    
    function calculateRunway() public returns (uint) {
		uint totalSalary = 0;
		for (uint i = 0; i < employees.length; i++) {
			totalSalary += employees[i].salary;
		}
		return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public returns (bool) {
    	return calculateRunway()>0;
    }
    
    function getPaid() public {
    	var (employee, index) = _findEmployee(msg.sender);
    	assert(employee.id != 0x0);

    	uint nextPayday = employee.lastPayday + payDuration;
    	assert(nextPayday < now);
    	employees[index].lastPayday = nextPayday;
    	employee.id.transfer(employee.salary);
    }
}
