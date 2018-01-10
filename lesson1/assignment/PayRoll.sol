pragma solidity ^0.4.14;

contract PayRoll {
    uint salary = 1 wei; // finney= 10^15 wei, ether= 10^18 wei
    address boss;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayDay = now;
    
    
     function PayRoll(){
         boss=msg.sender;        // 指定boss
     }
    
    // 充值 ， 需要 向  它  转钱
    function addFund() payable returns (uint){ //  payable    表示可以 接收  钱 
         
        return this.balance;
    }
    
    // 初始化员工 
    function updateEmployee(address e, uint money){
        require(boss==msg.sender);
        
        employee=e;
        uint prev_salary=salary;
        uint prev_lastPayDay=lastPayDay;
        
        salary=money*1 ether;
        lastPayDay=now;
        
        if (employee != 0x0) {
            uint payment = prev_salary * (now - prev_lastPayDay) / payDuration;
             employee.transfer(payment);
         }
    }
    
    
    function calculateRunaway() returns (uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunaway()>0; // 不要 带 this， 降低 gas消耗 ，  变为  jump 调用 
        
    }
    
    
    function getPaid() constant returns (uint){
         
         require(msg.sender==employee);
        
        
        // 这里使用局部变量， 减少 多余 的  计算 ， 节省   gas 。
        uint nextPayDay=lastPayDay+payDuration;
        
        //assert(nextPayDay < now); //效果等同下面的revert()
        
        if(nextPayDay<now){
            lastPayDay=nextPayDay;
            // 把 转钱的操作放到最后在， 内部变量修改完后 再给外部  钱 
            employee.transfer(salary);
        }else{
            // throw;   消耗  Gas
            revert(); // 剩余未消耗 的  GAS会还回来  
        }
    }
    
}