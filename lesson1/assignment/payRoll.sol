/*第一节课作业
题目：可添加，删除，更新员工信息（工资，发工资时间间隔）的薪酬系统
实现：1.只有管理员owner可以进行员工的信息添加，删除，更新
      2.只有管理员owner可以增加资金池资金量以及查看资金池总资金量
      3.只有员工列表中的成员才可申请获得工资，且要求两次申请间隔需大于设定间隔
      4.只有员工列表中的成员才可查看资金池中资金是否可满足自己下次资金的发放
*/
pragma solidity ^0.4.14;

contract Payroll {
    struct attribute {
        bool assigned;
        uint payDuration;
        uint salary;
        uint lastPayday;
    }
    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    mapping(address => attribute) employee;
    
    function addEmployee(address e, uint s, uint d) {
        require(msg.sender == owner);
        require(!employee[e].assigned);
        require(e!=0x0);
        
        employee[e].payDuration = d * 1 seconds;
        employee[e].salary = s * 1 ether;
        employee[e].lastPayday = now;
        employee[e].assigned = true;
    }
    
    function updateEmployee(address e, uint s, uint d) {
        require(msg.sender == owner);
        require(employee[e].assigned);
        require(e!=0x0);
        
        employee[e].payDuration = d * 1 seconds;
        employee[e].salary = s * 1 ether;
        employee[e].lastPayday = now;
    }
    
    function deleteEmployee(address e) {
        require(msg.sender == owner);
        require(employee[e].assigned);
        require(e!=0x0);

        employee[e].salary = 0 ether;
        employee[e].assigned = false;
    }
    

    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function hasEnoughFund() returns (bool) {
        require(employee[msg.sender].assigned);
        return this.balance > employee[msg.sender].salary;
    }
    
    function getPaid() {
        require(employee[msg.sender].assigned);
        
        uint nextPayday = employee[msg.sender].lastPayday + employee[msg.sender].payDuration;
        require(nextPayday < now);

        employee[msg.sender].lastPayday = now;
        msg.sender.transfer(employee[msg.sender].salary);
    }
}