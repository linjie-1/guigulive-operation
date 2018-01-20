pragma solidity ^0.4.15;

//import "zeppelin-solidity/contracts/ownership/Ownable.sol";
//import "zeppelin-solidity/contracts/math/SafeMath.sol";
import './Ownable.sol';
import './SafeMath.sol';


contract PayRoll is Ownable {
    
    using SafeMath for uint;
    
    struct Employee{
        address id;
        uint salary;        // finney= 10^15 wei, ether= 10^18 wei
        uint lastPayDay;
    }

    mapping(address=>Employee) public employeeList;
    uint constant payDuration = 10 seconds;
    
    uint totalSalary=0;//总的薪水
    
    
     
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
     
     
     /*
     使用 onlyBoss 这个 modifier之后，就不需要了
        require(boss==msg.sender);
     
     modifier onlyBoss{
         require(msg.sender==boss);
         _; //占位符，后续的代码会替换出现在这里
     }*/
     
     
     modifier employeeExist(address employeeId){
         var e=employeeList[employeeId];
         assert(e.id!=0x0);
         _;
     }
     
    
     
     
     
    
    // 充值 ， 需要 向  它  转钱
    function addFund() payable returns (uint){ //  payable    表示可以 接收  钱 
        return this.balance;
    }
    
    // 初始化员工 
    function addEmployee(address employeeId, uint money) onlyOwner  {

        var employee=employeeList[employeeId];
        
        assert(employee.id==0x0);
        
        var money_ether=money.mul(1 ether);
    
        employeeList[employeeId]=Employee(employeeId, money_ether ,now);
        
        totalSalary=totalSalary.add(money_ether);
    }
    
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday /*返回命名参数*/){
        var employee=employeeList[employeeId];
        
        //返回值，2种方法：
        //return (employee.salary, employee.lastPayDay);
        salary=employee.salary;
        lastPayday=employee.lastPayDay;
    }
    
    //更改员工地址
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner employeeExist(oldEmployeeId){
       var (oldsalary, oldLastPayday)=checkEmployee(oldEmployeeId);
       var (salary, lastPayday)=checkEmployee(newEmployeeId);
       assert(salary==0);//新的Employee应该不存在
       
        removeEmployee(oldEmployeeId);//移除老地址，结清工资
        
        addEmployee(newEmployeeId,oldsalary);//新地址，薪水还是原来的数目，结算日期是now
        
    }
    
    
    
    
    // 移除员工 
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
    
        var employee=employeeList[employeeId];
       
        _partialPay(employee);
        delete employeeList[employeeId];
           
        totalSalary=totalSalary.sub(employee.salary);
       
    }
    
    // 更新员工 
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        
       var employee=employeeList[employeeId];
       
       _partialPay(employee);
       
       var money_ether=salary * 1 ether;
       var prev_salary=employee.salary;
       employee.salary=money_ether;
       employee.lastPayDay=now;
        
        totalSalary=totalSalary.sub(prev_salary).add(money_ether);  //更新薪水，把原来的减去，新的薪水加上
    }
    
    
    
    //计算剩余的钱，看看是否还够发工资，大于0就是还有余额
    function calculateRunaway() returns (uint){
        //这里每次都循环遍历，太消耗Gas，改为一个成员变量保存totalSalary
        
        return this.balance/(totalSalary==0?1:totalSalary);
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunaway()>0; // 不要 带 this， 降低 gas消耗 ，  不带this,变为  jump 调用 
        
    }
    
    
    function getPaid() employeeExist(msg.sender) constant returns (uint) {
        var sender=msg.sender;
        var employee=employeeList[sender];
        
        // 这里使用局部变量， 减少 多余 的  计算 ， 节省   gas 。
        uint nextPayDay=employee.lastPayDay.add(payDuration);
        
        assert(nextPayDay < now); //效果等同的revert()
        
        //employee是对map里面的对象的引用，所以这里可以直接更改该对象，跟数组查找返回的效果不一样
        employee.lastPayDay=nextPayDay;
        // 把 转钱的操作放到最后在，内部变量修改完后再给外部钱 
        employee.id.transfer(employee.salary);
        
    }
    
}