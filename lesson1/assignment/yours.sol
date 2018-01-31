pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() public {
        owner = msg.sender;
    }
    
    function updateEmployee(address e) public {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        lastPayday = now;
    }
    
    function updateSalary(uint s) public {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getBalance() returns(uint) {
        return this.balance;
    }
    
    function getPaid() public returns (uint){
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
        return this.balance;
    }
}
