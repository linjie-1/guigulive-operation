## 区块链开发第三课


### MAPPING(哈希表)
- 类似于map(c++)
- key(bool,int,address,string) 只有这四种类型可以用
- value（任何类型）
- mapping(address => Empolyee) employees
- 只能做成员变量，不能做本地局部变量

### MAPPING底层实现
- 不使用数组和链表，不需要扩容
- hash函数为kecash256hash,在storage上存储，理论无限大的哈希表
- 无法native的遍历整个mapping（不能统计总数）
- 赋值 employess[key] = value
- 取值 value = employees[key]
- value是引用，在storage上存储，可以直接修改
- 当key不存在，value = type‘s default

引用类型相关学习 http://liyuechun.org/2017/09/30/solidity-contract-0006/
使用mapping是为了减少gas的消耗

### 函数参数返回进阶
- 命名参数返回    
    function checkEmployee(address employeeId) returns(uint salary,uint lastPayday){
        var employee = employees[employeeId];
        return (employee.salary,employee.lastPayday);
        
    }
- 命名返回参数直接赋值
    function checkEmployee(address employeeId) returns(uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
#### 函数参数返回进阶
- public 谁都可见
- external 只有外部调用可见
- internal 外部调用不可见，内部和子类可见
- private 只有当前合约可见
