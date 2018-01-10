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
    function addFun() payable returns (uint){
        return this.balance;
    }

    //换个人
    function changeEmployee(address _employee) {
        require(msg.sender == boss && _employee!=0x0);
        //结清上一个员工工资
        uint num = caculateSalaryNum();
        if(employee!=0x0 && num>0){
            lastPayDay = lastPayDay + payDuration * num;
            employee.transfer(salary * num);
        }
        employee = _employee;
        lastPayDay = now;
    }

    //给个工资标准
    function changeSalary(uint _salary) {
        require(msg.sender == boss);
        //按上一个工资标准结清
        uint num = caculateSalaryNum();
        if(employee!=0x0 && num>0){
            lastPayDay = lastPayDay + payDuration * num;
            employee.transfer(salary * num);
        }
        salary = _salary;
    }

    //计算能发工资的次数
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }

    //计算应该领几次工资
    function caculateSalaryNum() returns (uint) {
        return (now - lastPayDay) / payDuration;
    }

    //老板还有钱发工资么
    function hasEnouthFound() returns (bool) {
        return caculateRunway() > 0;
    }

    //领钱
    //TODO 一无所有的人是不能领钱的，先去借点手续费再说
    function getPaid(){
        //自己领自己的
        require(employee == msg.sender);
        //老板有钱
        require(hasEnouthFound());

        uint num = caculateSalaryNum();
        if (num > 0) {
            lastPayDay = lastPayDay + payDuration * num;
            employee.transfer(salary * num);
        }
    }

}
