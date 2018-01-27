/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    uint constant payDuration = 10 seconds;

    address employee;
    address owner;
    //上次支付时间
    uint lastPayday = now;
    uint salary = 1 ether;

    function Payroll() {
        //msg 需查询以太坊里的消息的概念
        owner = msg.sender;
    }
    
    //设置地址和工资额+新增
    function updateEmployee(address e, uint s) {
        // 检测发送地址
        require(msg.sender == owner);
        // 检测是否为空
        assert(e != 0x0);
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    //付钱
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function colculateRunway() returns (uint) {
        return this.balance / salary;
    }
    // 支付次数
    function hasEnoughFund() returns (bool) {
        return colculateRunway() > 0;
    }
    // 发工资
    function getPaid() {
        require(msg.sender == employee);
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay < now) {
            lastPayday = nextPayDay;
            employee.transfer(salary);
        }
      
    }

}