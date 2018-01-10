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

    //function to change employee's ssalary
    function changeEmployeeSalary(uint s){
        require(msg.sender == owner);
        salary = s * 1 ether;
    }
    
    //function to change emplyee's wallet
    function changeEmployeeAdress(address newAddr, bool newEmployee){
        require(msg.sender == owner);
        
        //if neweEmployee = false => same person just new address, like changing to new deposit bank acocunt 
        //In this case no need to payoff previous payment first
        if(employee != 0x0 && newEmployee){
            //pay off the remaining funds to previous employee
            uint payment = salary * (now - lastPayday) / payDuration;
            lastPayday = now;
            employee.transfer(payment);
        }
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