/*第一节课作业基本版
题目：可更新员工信息（工资，地址）的单员工智能合约系统
实现：1.只有管理员owner可以进行员工的地址及工资更新
      2.只有管理员owner可以增加资金池资金量
      3.只有员工才可申请获得工资，且要求两次申请间隔需大于设定间隔
      4.只有员工才可查看资金池中资金是否可满足自己下次资金的发放
*/
pragma solidity ^0.4.14;

contract Payroll {
    
    address employer = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint payDuration = 10 seconds;
    uint salary = 1 ether;
    uint lastPayday = now;
    
    // new function updateAdress & updateSalary
    function updateAdress(address e) {
        require(msg.sender == employer);
        require(e!=0x0);
        
        employee = e;
        lastPayday = now;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == employer);
        require(s!=0);
        
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == employer);
        return this.balance;
    }
    
    function hasEnoughFund() returns (bool) {
        require(employee == msg.sender);
        return this.balance > salary;
    }
    
    function getPaid() {
        require(employee == msg.sender);
        
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = now;
        msg.sender.transfer(salary);
    }
}