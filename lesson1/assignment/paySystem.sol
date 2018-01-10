pragma solidity ^0.4.14;

contract Payroll {
    address owner;
    address employee;
    uint salary;
    uint lastPayday;
    
    uint constant payDuration = 10 seconds;
    
    function ImOwner() public returns (address) {
        return owner = msg.sender;
    }
    
    function setEmployee() public returns (address) {
        return employee = msg.sender;
    }
    
    function ownerUpdateSalary(uint newSalary) public {
        require(msg.sender == owner);
        
        salary = newSalary;
        lastPayday = now;
    }
    
    function addMoney() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughMoney() public returns (bool) {
        return calculateRunway() > 1;
    }
    
    function getPaid() public {
        require(msg.sender == employee);
 
        uint shouldPayday = lastPayday + payDuration;
        assert(shouldPayday < now);
        
        lastPayday = shouldPayday;
        employee.transfer(salary);
    }
}
