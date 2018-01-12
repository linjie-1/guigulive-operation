pragma solidity ^0.4.14;

// report: https://medium.com/@gongf05/smart-contract-class-1-summary-ea8338feefd5

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    // constructor - initialize values
    function Payroll() {
        owner = msg.sender;
        lastPayday = now;
    }
    
    // check balance of employee to verify they had successfully got paid
    // Note: only employee has permission to check their own balance for privacy concern
    function checkEmployeeBalance(address e) returns (uint){
        require(msg.sender == employee);
        
        if (e != 0x0) {
            return e.balance;   
        }
    }
    
    // set salary value - default is wei -> change to be unit of "ether"
    // Note: only the role of "owner" can set the salary value
    function setSalary(uint value) returns (uint){
        require(msg.sender == owner);
        
        if( value < 0 ) {
            revert();
        }
        
        salary = value * 1 ether;
        return salary;
    }
    
    // update employee address
    // Note: only owner can change the employee address (Here we consider single employee)
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        employee = e;
        lastPayday = now;
    }
    
    // owner add fund into the contract
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // calculate how many times the employee can get paid
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    // check whether the contract has enough fund to pay employee
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    // employee get paid from the contract
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        if( nextPayday > now){
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
