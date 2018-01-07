/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 5 seconds;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee(address e, uint s){
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
    
    function getPaid(){
        require(msg.sender == owner);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
