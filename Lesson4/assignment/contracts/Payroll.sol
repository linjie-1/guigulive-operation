pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    uint totalSalary;
    address owner;
    mapping(address=>Employee) employees;

    function Payroll() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
    	require(msg.sender == owner);
    	_;
    }

    modifier employeeExist(address employeeId) { 
    	var employee = employees[employeeId];
    	assert(employee.id != 0x0);
    	_; 
    }

    modifier employeeNotExist(address employeeId) { 
    	var employee = employees[employeeId];
    	assert(employee.id == 0x0);
    	_; 
    }
    
    function _partialPaid(Employee employee) private {
    	uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    	employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId){
    	employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    	totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
    	var employee = employees[employeeId];

    	_partialPaid(employee);

    	totalSalary -= employee.salary;
    	delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
    	var employee = employees[employeeId];
    	_partialPaid(employee);
    	totalSalary -= employees[employeeId].salary;
    	employees[employeeId].salary = salary * 1 ether;
    	totalSalary += employees[employeeId].salary;
    	employees[employeeId].lastPayday = now;
    }

    function changePaymentAddress(address newEmployeeId) public employeeExist(msg.sender) employeeNotExist(newEmployeeId){
    	//Only the employee can modify it's own address
    	var employee = employees[msg.sender];
    	uint oldlastPayday = employee.lastPayday;
    	uint oldSalary = employee.salary;
    	delete employees[msg.sender];

    	//create new employee
    	employees[newEmployeeId] = Employee(newEmployeeId, oldSalary, oldlastPayday);  	
    }
    
    function checkEmployee(address employeeId) public returns (uint salary, uint lastPayday) {
    	var employee = employees[employeeId];
    	salary = employee.salary;
    	lastPayday = employee.lastPayday;
    }
    
    function addFund() payable public returns (uint) {
    }
    
    function calculateRunway() public returns (uint) {
		return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public returns (bool) {
    	return calculateRunway()>0;
    }
    
    function getPaid() public employeeExist(msg.sender){
    	var employee = employees[msg.sender];

    	uint nextPayday = employee.lastPayday + payDuration;
    	assert(nextPayday < now);
    	employees[msg.sender].lastPayday = nextPayday;
    	employee.id.transfer(employee.salary);
    }
}
