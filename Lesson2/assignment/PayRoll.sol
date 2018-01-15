pragma solidity ^0.4.14;

contract PayRoll {
    
    struct Employee{
        address id;
        uint salary;        // finney= 10^15 wei, ether= 10^18 wei
        uint lastPayDay;
    }

    //成员变量存储在storage中
    address boss;
    Employee[] employeeList;
    uint constant payDuration = 10 seconds;
    
    uint totalSalary=0;//总的薪水
    
    
    
     function PayRoll(){
         boss=msg.sender;        // 指定boss
     }
     
     //返回参数默认存在 memory中
     // (Employee storage, uint) 这里定义的storage表示，返回的employee是指向storage的一个引用
     function _findEmployee(address employeeId) private returns (Employee, uint){
         
         for(var i=0;i<employeeList.length;i++){
             if(employeeList[i].id==employeeId){
                 return (employeeList[i], i);
             }
         }
     }
     
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
        
        var (employee, index)=_findEmployee(employeeId);
        
        assert(employee.id==0x0); //如果不等于0 就报错,说明找到了，无需添加，后面的语句不会执行
        
        var money_ether=money * 1 ether;
       
        employeeList.push(Employee(employeeId, money_ether ,now));
        
        totalSalary+=money_ether;
       
    }
    
    
    // 移除员工 
    function removeEmployee(address employeeId){
        require(boss==msg.sender);
        
       var (employee, index)=_findEmployee(employeeId);
       
       assert(employee.id!=0x0);//不存在就报错，虚拟机会 revert()
       
           _partialPay(employee);
           delete employeeList[index];
           //填充刚才删除的空，把最后一个元素移动到刚才的位置
           employeeList[index]=employeeList[employeeList.length-1];
           employeeList.length-=1;// length -- 缩容
           
           totalSalary-=employee.salary*1 ether;
       
    }
    
    // 更新员工 
    function updateEmployee(address employeeId, uint salary){
        require(boss==msg.sender);
        
       var (employee, index)=_findEmployee(employeeId);
       
       assert(employee.id!=0x0);//存在就报错，虚拟机会 revert()
       
       _partialPay(employee);
       
       var money_ether=salary * 1 ether;
       var prev_salary=employeeList[index].salary;
       employeeList[index].salary=money_ether;
       employeeList[index].lastPayDay=now;
        
        totalSalary=totalSalary-prev_salary+money_ether;  //更新薪水，把原来的减去，新的薪水加上
         
       
    }
    
    
    
    //计算剩余的钱，看看是否还够发工资，大于0就是还有余额
    function calculateRunaway() returns (uint){
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
         var (employee,index)=_findEmployee(sender);
        
        assert(employee.id!=0x0);
        
        // 这里使用局部变量， 减少 多余 的  计算 ， 节省   gas 。
        uint nextPayDay=employee.lastPayDay+payDuration;
        
        assert(nextPayDay < now); //效果等同的revert()
        employee.lastPayDay=nextPayDay;
        // 把 转钱的操作放到最后在，内部变量修改完后再给外部钱 
        employee.id.transfer(employee.salary);
        
    }
    
}



Gas 消耗记录：

employee							gas			transaction cost				execution cost 
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c		3000000		22962							1690
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db		3000000		23755							2483
0x583031d1113ad414f02576bd6afabfb302140225		3000000		24548							3276	
0xdd870fa1b7c4700f2bd7f44238821c26f7392148		3000000		25341							4069

calculateRunway的优化后的 Gas消耗:
employee							gas			transaction cost				execution cost 
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c		3000000		22102							830
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db		3000000		22102							830
0x583031d1113ad414f02576bd6afabfb302140225		3000000		22102							830	
0xdd870fa1b7c4700f2bd7f44238821c26f7392148		3000000		22102							830

优化后，gas消耗减少了。目标达到
