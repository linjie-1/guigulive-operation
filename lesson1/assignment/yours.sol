pragma solidity ^0.4.14;
contract Payroll {
    uint constant payDuration = 10 seconds;

    address boss = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary;
    address employee;
    uint lastPayday = now;

    //获取员工地址和工资
    function updateEmployee(address e,uint s) {
        employee = e;
        salary = s * 1 finney;
    }
    //存钱
    function addFund() payable returns (uint) {
        return this.balance;
    }
    //余额是否够发工资
    function hasEnoughFund() returns (bool) {
        return this.balance / salary > 1;
    }
    //领取工资
    function getPaid() {
        require(msg.sender == boss);
        
        if (employee != 0x0 && employee != boss) {
            uint payment = salary * (now - lastPayday) / payDuration;
            if(hasEnoughFund()){
              lastPayday = now;
              employee.transfer(payment);
            }else{
              revert();
            }
        }else{
          revert();
        }
    }
}
