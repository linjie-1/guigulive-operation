pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 0;
    address employee = 0x0;
    uint lastPayday;

    function Payroll() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
    	require(msg.sender == owner);
    	_;
    }

    modifier onlyEmployee {
    	require(msg.sender == employee);
    	_;
    }

    modifier validSalary {
    	require(salary > 0);
    	_;
    }
    
    function updateEmployeeSalary (uint s) public onlyOwner {
    	//pay the rest amount first
    	payRest();
    	salary = s * 1 ether;
    	lastPayday = now;
    }

    function updateEmployeeAddress(address e) public onlyOwner {
    	//pay the rest amount first
    	payRest();
    	employee = e;
    	lastPayday = now;
    }

    // This private function will be called if you update employee address or salary
    function payRest() private {
    	if(employee != 0x0 && salary > 0){
    		uint payment = salary * (now - lastPayday) / payDuration;
        	employee.transfer(payment);
    	}
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public validSalary returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public validSalary returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public onlyEmployee {
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
