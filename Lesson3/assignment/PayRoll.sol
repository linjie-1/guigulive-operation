pragma solidity ^0.4.14;

contract PayRoll {
    
    struct Employee{
        address id;
        uint salary;        // finney= 10^15 wei, ether= 10^18 wei
        uint lastPayDay;
    }

    //成员变量存储在storage中
    address boss;
    mapping(address=>Employee) employeeList;
    uint constant payDuration = 10 seconds;
    
    uint totalSalary=0;//总的薪水
    
    
    
     function PayRoll(){
         boss=msg.sender;        // 指定boss
     }
     
     //存储employee信息改为map后，下面的函数不需要了。
     //返回参数默认存在 memory中
     // (Employee storage, uint) 这里定义的storage表示，返回的employee是指向storage的一个引用
     /*function _findEmployee(address employeeId) private returns (Employee, uint){
         for(var i=0;i<employeeList.length;i++){
             if(employeeList[i].id==employeeId){
                 return (employeeList[i], i);
             }
         }
     }*/
     
     function _partialPay(Employee employee) private {
            //除法会把小数抹掉，所以要先乘以salary后再除
             uint pay=employee.salary *(now-employee.lastPayDay)/payDuration; 
             employee.id.transfer(pay);
             employee.lastPayDay=now;
     }
     
     
     
    
    // 充值 ， 需要 向  它  转钱
    function addFund() payable returns (uint){ //  payable    表示可以 接收  钱 
        return this.balance;
    }
    
    // 初始化员工 
    function addEmployee(address employeeId, uint money){
        require(boss==msg.sender);
        
        //var (employee, index)=_findEmployee(employeeId);
        var employee=employeeList[employeeId];
        
        assert(employee.id==0x0); //如果不等于0 就报错,说明找到了，无需添加，后面的语句不会执行
        
        var money_ether=money * 1 ether;
       
        //employeeList.push(Employee(employeeId, money_ether ,now));
        employeeList[employeeId]=Employee(employeeId, money_ether ,now);
        
        
        totalSalary+=money_ether;
       
    }
    
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday /*返回命名参数*/){
        var employee=employeeList[employeeId];
        //return (employee.salary, employee.lastPayDay);
        salary=employee.salary;
        lastPayday=employee.lastPayDay;
    }
    
    
    
    
    
    
    // 移除员工 
    function removeEmployee(address employeeId){
        require(boss==msg.sender);
        
       //var (employee, index)=_findEmployee(employeeId);
       var employee=employeeList[employeeId];
       
       assert(employee.id!=0x0);//不存在就报错，虚拟机会 revert()
       
           _partialPay(employee);
           delete employeeList[employeeId];
           
           totalSalary-=employee.salary*1 ether;
       
    }
    
    // 更新员工 
    function updateEmployee(address employeeId, uint salary){
        require(boss==msg.sender);
        
       var employee=employeeList[employeeId];
       
       assert(employee.id!=0x0);//存在就报错，虚拟机会 revert()
       
       _partialPay(employee);
       
       var money_ether=salary * 1 ether;
       var prev_salary=employee.salary;
       employee.salary=money_ether;
       employee.lastPayDay=now;
        
        totalSalary=totalSalary-prev_salary+money_ether;  //更新薪水，把原来的减去，新的薪水加上
         
       
    }
    
    
    
    //计算剩余的钱，看看是否还够发工资，大于0就是还有余额
    function calculateRunaway() returns (uint){
        //这里每次都循环遍历，太消耗Gas，改为一个成员变量保存totalSalary
        /*uint total=0;
        for(var i=0;i<employeeList.length;i++){
            total+=employeeList[i].salary;
        }*/
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunaway()>0; // 不要 带 this， 降低 gas消耗 ，  不带this,变为  jump 调用 
        
    }
    
    
    function getPaid() constant returns (uint){
        var sender=msg.sender;
        var employee=employeeList[sender];
        
        assert(employee.id!=0x0);
        
        // 这里使用局部变量， 减少 多余 的  计算 ， 节省   gas 。
        uint nextPayDay=employee.lastPayDay+payDuration;
        
        assert(nextPayDay < now); //效果等同的revert()
        
        //employee是对map里面的对象的引用，所以这里可以直接更改该对象，跟数组查找返回的效果不一样
        employee.lastPayDay=nextPayDay;
        // 把 转钱的操作放到最后在，内部变量修改完后再给外部钱 
        employee.id.transfer(employee.salary);
        
    }
    
}