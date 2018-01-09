pragma solidity ^0.4.14;

contract Payroll{
    uint constant payDuration = 10 seconds;
    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 100 ether;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday = now;

    function Payroll() payable{
        owner = msg.sender;
    }

    function updateSalary(uint new_salary) payable returns (uint){
        require (msg.sender == owner);

        if(new_salary < 0){
            revert();
        }
        salary = new_salary * 1 ether;
        return salary;
    }

    function updateAddress(address new_employee) payable returns (address){
        require(msg.sender == owner);

        if(new_employee != 0x0){
            uint payment = salary *(now - lastPayday)/payDuration;
            employee.transfer(payment);
        }

        lastPayday = now;
        employee = new_employee;
        return employee;
        
    }

    function addFund() payable returns (uint){
        return this.balance;
    }

    function calculateRunway() returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0 ;
    }

    function getPaid(){
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        if( nextPayday > now){
            revert();
        }

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}

