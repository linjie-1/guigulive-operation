<<<<<<< HEAD
=======
# homework1
>>>>>>> 15f22fd4ee2df7d6048b764d5794f999dc23a881
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
<<<<<<< HEAD
    address employee = 0x0;
    uint lastPayday = now;

=======
    address employee;
    uint lastPayday;
    
// use update employee function to update employee information, and also checking if the account is the owner.
    
>>>>>>> 15f22fd4ee2df7d6048b764d5794f999dc23a881
    function Payroll() {
        owner = msg.sender;
    }
    
<<<<<<< HEAD
    //update employee
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        //check to makesure if employee address is valid and not same as pervious address
        //if valid clear the previous employees balance before update to new employee
        if (e != 0x0 && employee != e) {
            payPreviousBalance();
        }else{
            revert();
        }
        employee = e;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == owner);
        uint newsalary = s * 1 ether;
        
        //check if salay remain the same then skip the change
        if (newsalary == salary){
            revert();
        }
        payPreviousBalance();
        salary = s * 1 ether;
    }
    
    function payPreviousBalance() {
        if (salary > 0 && employee != 0x0){
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            lastPayday = now;
        }
=======
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
>>>>>>> 15f22fd4ee2df7d6048b764d5794f999dc23a881
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
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
