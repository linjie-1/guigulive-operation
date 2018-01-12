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
    
    function updateE(address newE, uint newS) payable {
        require (msg.sender == owner);
        if (newE != 0x0){
            uint lastSalary = (now - lastPayday) / payDuration * salary;
            employee.transfer(lastSalary);
        }
        employee = newE;
        lastPayday = now;
        salary = newS * 1 ether;
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
    
    function getPaid() payable {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
