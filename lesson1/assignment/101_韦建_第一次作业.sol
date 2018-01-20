pragma solidity ^0.4.14;

contract payroll{
    uint salary = 2 ether;
    address owner;
    address employee;
    uint constant payduration = 10 seconds;
    uint lastpayday = now;


    function Payroll() {
        owner = msg.sender;
    }
    
    function addfund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns(uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns(bool){
         return calculateRunway() > 0;
    }
    
    function updateemployee(address e, uint s){
        require(msg.sender == owner);
        
        if(employee != 0x00){
            uint needpay = (now - lastpayday) * (salary / payduration);
            employee.transfer(needpay);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastpayday = now;
    }
    
    function getpaid() {
        require(msg.sender == employee);
        uint nextpayday = lastpayday + payduration;
        
        if(nextpayday < now){
            lastpayday = nextpayday;
            employee.transfer(salary);
        }else{
            revert();
        }
    }
}
