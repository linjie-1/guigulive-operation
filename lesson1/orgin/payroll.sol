pragma solidity ^0.4.14;

contract Payroll {
    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee;
    uint salary;
    uint lastPayday;
    
    uint constant payDuration = 30 days;
    
    function ownerUpdateEmployee(address newAddress, uint newSalary) public {
        require(msg.sender == owner);
        
        if (employee != address(0)) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = newAddress;
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
