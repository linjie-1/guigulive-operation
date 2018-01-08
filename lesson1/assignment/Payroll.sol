#39_王博远 第一次作业
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 5 seconds;

    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 1 ether;
    address employee;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeAddress(address newAddress) returns (address){
        if(msg.sender != owner || owner == newAddress) {
            revert();
        }
        
        employee = newAddress;
        return employee;
    }
    
    function updateEmployeeSalary(uint e) returns (uint){
        if(msg.sender != owner) {
            revert();
        }
        
        salary = e;
        return salary;
    }
    
    function updateEmployeeSalary(address newAddress,uint e){
        if(msg.sender != owner || owner == newAddress) {
            revert();
        }
        
        employee = newAddress;
        salary = e;
    }
    
    function getEmployeeAddress() returns (address){
        return employee;
    }
    
    function getOwnerAddress() returns (address){
        return owner;
    }
    
    function getMsgSenderAddress() returns (address){
        return msg.sender;
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
    
    function getPaid() returns(uint){
        if(msg.sender != owner){
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
        return salary;
        
    }
}
