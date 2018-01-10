/*作业请提交在这个目录下*/
pragma solidity ^0.4.0;

contract Payroll {
    uint salary = 1 ether;
    address employee;
    address boss;
    uint constant payDuration = 10 seconds;
    uint lastPayday;

    function Payroll(){
        boss = msg.sender;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() public returns (bool){
        return calculateRunway() > 0;
    }

    function getPaid() {
        require(msg.sender == employee);

        uint nextPayDay = lastPayday + payDuration;
        require (nextPayDay < now);

        lastPayday = nextPayDay;
        employee.transfer(salary);
    }

    function changeSalary(uint newSalary) {
        require(msg.sender == boss);
        salary = newSalary * 1 ether;
    }

    function updateEmployee(address a) {
        require(msg.sender == boss);

        employee = a;
    }
}