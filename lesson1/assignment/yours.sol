/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeAddress(address e ){
        require(msg.sender == owner);
        
        if (employee != e) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            employee = e;
            lastPayday = now;
        }
    }
    
    function updateEmployeeSalary(uint s){
        require(msg.sender == owner);
        
        if (salary != s) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            salary = s * 1 ether;
            lastPayday = now; 
        }
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
    
    function getPaid() payable {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function getFullPaid() payable{
        require(msg.sender == employee);
        
        uint gaps = (now - lastPayday);
        uint numPays =  gaps / payDuration;
        assert(numPays > 0);
        
        lastPayday = lastPayday + (numPays * payDuration);
        uint amount = salary * numPays;
        employee.transfer(amount);
    }
}