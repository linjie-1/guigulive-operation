/*作业请提交在这个目录下*/
// Tao Zhang 82 work on 1/9/2018
// Configed and tested on http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js portal
pragma solidity ^0.4.14;

// based on the ether price Payroll
contract Payroll {
    // init contract variables
    uint constant payDuration = 30 days;
    uint salary = 1 ether;
    address employeeAddr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    uint lastPayday = now;
    // init:
    
    // update salary
    function updateSalary(uint newSalary) public {
        // sender authentication
        if (msg.sender != employeeAddr) {
            revert();
        }
        salary = newSalary;
    }
    
    // update employeeAddress
    function updateAddress(address newAddress) public {
        // Can we extract sender authentication to a common function
        if (msg.sender != employeeAddr) {
            revert();
        }
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
        if (msg.sender != employeeAddr) {
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        lastPayday = lastPayday + payDuration;
        employeeAddr.transfer(salary);
    }
}
