pragma solidity ^0.4.14; 


contract Payroll { 
	struct Employee { 
		address id; 
		uint salary; 
		uint lastPayday; 
	} 

	uint constant payDuration = 10 seconds; 
	address owner; 
	Employee[] employeeArray; 
	uint totalSalary = 0 ether;

	function Payroll() public { 
		owner = msg.sender; 
	} 

	function _partialPaid(Employee employee) private { 
		uint payment = employee.salary * (now - employee.lastPayday) / payDuration; 
		employee.id.transfer(payment); 
	} 

	function _findEmployee(address employeeId) private view returns (Employee, uint) { 
		for (uint i = 0; i < employeeArray.length; i++) { 
			if (employeeArray[i].id == employeeId) { return (employeeArray[i], i); } 
		} 
	} 

	function addEmployee(address employeeId, uint salary) public { 
		require(msg.sender == owner); 
		var (employee, ) =  _findEmployee(employeeId); 
		assert(employee.id == 0x0); 
		employeeArray.push(Employee(employeeId, salary * 1 ether, now)); 
		totalSalary += salary * 1 ether;
	} 

	function removeEmployee(address employeeId) public {
		require(msg.sender == owner);

		var (employee, index) =  _findEmployee(employeeId); 
		assert(employee.id == 0x0);

		_partialPaid(employee);
		
		totalSalary -= employee.salary;
		delete employeeArray[index];
		employeeArray[index] = employeeArray[employeeArray.length - 1];
		employeeArray.length -= 1;
		
			
	}

	function updateEmployee(address employeeId, uint salary) public { 
		require(msg.sender == owner); 
		var (employee, ) =  _findEmployee(employeeId); 
		assert(employee.id == 0x0); 
		
		
		_partialPaid(employee); 
		
		
		totalSalary = totalSalary - employee.salary + salary;
		employee.salary  = salary; 
		employee.lastPayday = now; 
	} 

	function addFund() public payable returns (uint) { 
		return this.balance; 
	} 

	function calculateRunway() public view returns (uint) { 
		return this.balance / totalSalary; 
	}
	
	function hasEnoughFund() public view returns (bool) {
		return calculateRunway() > 0; 
	} 

	function getPaid() public { 
		var (employee, ) = _findEmployee(msg.sender); 
		assert(employee.id != 0x0); 
		uint nextPayday = employee.lastPayday + payDuration; 
		assert(nextPayday < now); 
		employee.lastPayday = nextPayday; 
		employee.id.transfer(employee.salary); 
	} 
}

