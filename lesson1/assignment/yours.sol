/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payCycle = 10 seconds;
    
    address owner;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 1 ether;
    uint lastPayday = now;
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() returns(uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns(bool) {
        return calculateRunway() > 0;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    function getOwner() returns(address) {
        return owner;
    }
    
    function getPaid() {
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayday = lastPayday + payCycle;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        employee = e;
        salary = s * 1 ether;
    }

    
}
