pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    uint constant payDuration = 20 seconds;
    uint lastPayDay = now;
    uint nextPayDay;
    uint payment;
    //set up initial emloyee address
    address employer = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    //update employee address
    function changeEmployee(address e){
        require(msg.sender == employer);
        
        if (employee != 0x0){
            //pay accumulated salary to former employee
            payment = salary * (now - lastPayDay) / payDuration;
            lastPayDay = now;
            employee.transfer(payment);
        }
        employee = e;
    }
    
    //update employee salary
    function changeSalary(uint s){
        require(msg.sender == employer);
        
        if (employee != 0x0) {
            //pay accumulated salary to the current employee
            payment = salary * (now - lastPayDay) / payDuration;
            lastPayDay = now;
            employee.transfer(payment);
        }
        salary = s * 1 ether;
    }
    
    function calculateRunway() returns (uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    //updated
    function getPaid(){
        require(msg.sender == employee);
        
        nextPayDay = lastPayDay + payDuration;
        
        assert(nextPayDay <= now);
        lastPayDay = nextPayDay;
        payment = salary * (now - lastPayDay) / payDuration;
        employee.transfer(payment);
    }
}
