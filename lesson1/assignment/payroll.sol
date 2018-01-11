/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary = 1 ether;
    address employee = 0x0;
    uint lastPayday = now;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid() private {
        if(employee != 0x0){
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
    }

    function updateSalary(uint salary_ether){
        require(msg.sender == owner);
        
        _partialPaid();
        salary = salary_ether * 1 ether;
    }
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        _partialPaid();
        employee = e;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() >= 1;
    }
    
    function getPaid(){
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now && hasEnoughFund());
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
