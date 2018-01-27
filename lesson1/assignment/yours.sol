// version 2
pragma solidity ^0.4.14;
contract Payroll{

    uint salary = 1 ether;
    address employer ;
    address employee ;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
<<<<<<< 8e696b03f5f3967117777c84fa3c21c67fee1099
    
    function Payroll() {
        boss = msg.sender;
    }
    
    function updateEmployeeAddress(address a) {
        require(msg.sender == boss);
        
         if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = a;
        lastPayday = now;
    }
    
    function updateEmployeeSalary(uint s) {
        require(msg.sender == boss);
        
	if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        lastPayday = now;
        salary = s * 1 ether;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
=======

    function Payroll(){
        employer =  msg.sender;
    }

    function updateEmployeeAddress(address a) {
        require(msg.sender == boss);

         if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = a;
        lastPayday = now;
    }

    function updateEmployeeSalary(uint s) {
        require(msg.sender == boss);

        salary = s * 1 ether;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool){
>>>>>>> 第一课作业
        return calculateRunway() > 0;
    }

    function getPaid() {
<<<<<<< 1607599632a969961e62c8c7f8bc3d256a0257fb
<<<<<<< 8e696b03f5f3967117777c84fa3c21c67fee1099
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
=======
        if (msg.sender != employee){
            revert();
        }

        uint nextPayDay = lastPayday + payDuration;
=======
        require(msg.sender == employee);
>>>>>>> Update "update homework 1"

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

<<<<<<< 1607599632a969961e62c8c7f8bc3d256a0257fb
        lastPayday = nextPayDay;
>>>>>>> 第一课作业
=======
        lastPayday = nextPayday;
>>>>>>> Update "update homework 1"
        employee.transfer(salary);
    }
}
