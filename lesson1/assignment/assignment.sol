pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }
    
    function setEmployeeAddress(address addr){
    	require(msg.sender == owner);
    	require(addr != 0x0);

    	if (employee != 0x0){
    		uint currentPayTime = now - lastPayday;
    		if (currentPayTime>0){
    			uint payment = currentPayTime / payDuration * salary;
    			employee.transfer(payment);
    		}
    	}

    	lastPayday = now;
    	employee = addr;
    }
    
    function setEmployeeSalary(uint sal){
    	require(msg.sender == owner);
    	require(sal >= 0);

    	if (employee != 0x0){
    		uint currentPayTime = now - lastPayday;
    		if (currentPayTime>0){
    			uint payment = currentPayTime / payDuration * salary;
    			employee.transfer(payment);
    		}
    	}
    	
    	lastPayday = now;
    	salary = sal * 1 ether;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
