pragma solidity ^0.4.14;


contract Payroll {
    address public boss;

    address public employee;

    uint public salary = 1 ether;

    uint constant payDuration = 30 days;

    uint lastPayDay = now;

    function Payroll(){
        boss = msg.sender;
    }

    //给合约存点钱
    function addFun() payable returns(uint){
        return this.balance;
    }

    //换个人发工资
    function changeEmployee(address _employee) {
        if (msg.sender != boss) {
            revert();
        }
        employee = _employee;
        lastPayDay = now;
    }

    //给个工资标准
    function changeSalary(uint _salary) {
        if (msg.sender != boss) {
            revert();
        }
        salary = _salary;
    }

    //计算能发工资的次数
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }

    //老板还有钱发工资么
    function hasEnouthFound() returns (bool) {
        return caculateRunway() > 0;
    }

    //终于能领钱了
    //TODO 一无所有的人是不能领钱的，先去借点手续费再说
    function getPaid(){
        //自己领自己的
        if (employee != msg.sender) {
            revert();
        }
        //老板没钱了
        if (!hasEnouthFound()) {
            revert();
        }
        //今儿不发钱
        uint currentPayDay = lastPayDay + payDuration;
        if (currentPayDay > now) {
            revert();
        }

        lastPayDay = currentPayDay;
        employee.transfer(salary);
    }

}
