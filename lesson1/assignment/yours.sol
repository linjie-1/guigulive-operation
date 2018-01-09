/*作业请提交在这个目录下*/
=======
// version 2
pragma solidity ^0.4.14;
contract Payroll{

    uint salary = 1 ether;
    address employer ;
    address employee ;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;

    function Payroll(){
        employer =  msg.sender;
    }

    function payBalance(){
        if (employee != 0){
            uint payment  = salary * (now-lastPayday)/payDuration;
            employee.transfer(payment);
        }
    }

    function changeEmployee(address e){
        require(msg.sender == employer);
        payBalance();
        employee = e;
        lastPayday = now;
    }

    function changeSalary(uint s){
        require(msg.sender == employer);
        payBalance();
        salary = s * 1 ether;
    }

    function addFund() payable returns (uint){
        return this.balance;
    }

    function calculateRunway() returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }

    function getPaid() {
        if (msg.sender != employee){
            revert();
        }

        uint nextPayDay = lastPayday + payDuration;

        if ( nextPayDay > now){
            revert();
        }

        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
