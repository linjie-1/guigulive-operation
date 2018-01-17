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

    //function to change employee's salary
    //Input: number of ether for salary
    function changeEmployeeSalary(uint salary_in_ether){
        require(msg.sender == owner);
        if (employee != 0x0) {
            //payoff the previous salary first
            uint payment = salary * (now - lastPayday) / payDuration;
            salary = salary_in_ether * 1 ether;
            employee.transfer(payment);
        }
    }
    
    //function to change emplyee's wallet
    function changeEmployeeAdress(address newAddr){
        require(msg.sender == owner);
        employee = newAddr;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (salary == 0) return 0;
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }

}
