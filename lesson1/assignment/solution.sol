pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function setEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function getPayDuration() returns (uint) {
        return payDuration;
    }
    
    function calculateRunway() returns (uint) {
        assert(salary != 0);
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; // In EVM it's jump operation; if use this.calculateRunway() will use msg, gas cost is high 
    }
    
    function getPaid() {
	require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        if (nextPayday >= now) {
            revert(); // revert() will return unused gas but throw will not.
        }

        // the order is important; Always change internal param state first than transfer money
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}

