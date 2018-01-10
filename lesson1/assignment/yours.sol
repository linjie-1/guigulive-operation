/*作业请提交在这个目录下*/
// Tao Zhang 82 work on 1/9/2018
// Configed and tested on http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js portal
pragma solidity ^0.4.14;

// based on the ether price Payroll
contract Payroll {
    uint constant payDuration = 5 seconds;
    uint salary;
    address employeeAddr;
    address ownerAddr;
    uint lastPayday;

    // init:
    function Payroll() public {
        ownerAddr = msg.sender;
        employeeAddr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        salary = 1 ether;
        lastPayday = now;
    }
    
    // check owner and transfer salary
    function transferSalary() internal {
        // check if the owner
        employeeAddr.transfer(salary * (now - lastPayday) / payDuration);
    }
    
    // update salary
    function updateSalary(uint newSalary) public {
        // sender authentication
        require(msg.sender == ownerAddr);
        require(newSalary != salary);
        transferSalary();
        salary = newSalary;
    }
    
    // update employeeAddress
    function updateAddress(address newAddress) public {
        require(msg.sender == ownerAddr);
        require(newAddress != employeeAddr);
        transferSalary();
        employeeAddr = newAddress;
    }
    
    // addFund to the contract, fund from employer
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    // calculate how many times employee can get paid
    function calculateRunway() public view returns (uint) {
        return this.balance / salary;
    }
    
    // check if there's enough fund or not
    function hasEnoughFund() public view returns (bool) {
        return this.balance >= salary;
    }
    
    // pay the salary
    function getPaid() public {
        require(msg.sender == employeeAddr);
        require(nextPayday <= now);
        uint nextPayday = lastPayday + payDuration;
        lastPayday = nextPayday;
        employeeAddr.transfer(salary);
    }
}
