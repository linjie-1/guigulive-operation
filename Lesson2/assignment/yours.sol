/*作业请提交在这个目录下*/

/*
第1题：加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

增加几位员工时的Gas变化情况
   transaction cost , execution cost    , calculateRunway() cost
1     105162   82290    22966  1694
2      91003   68131    23747  2475
3      91844   68972    24528  3256
4      92685   69813    25309  4037
5      93526   70654    26090  4818
6      94367   71495    26871  5599
7      95208   72336    27652  6380
后面没有记录了，已经发现规律了

gas不断增大
addEmployee时，每次操作时gas增加841，calculateRunway时，每次gas增加781
在addEmployee代码中，调用了findEmployee()函数，里面要遍历查找一个员工，当员工人数越多时，查找操作的次数越多，gas就会消耗越多
在calculateRunway代码中，有一个for循环，每次要将所有员工的salary累加，并没有利用以前的交易中计算的中间结果，数组中元素越多，gas消耗就越多
*/


第二题：
为了老师批作业方便，只保留了更改的部分

contract Payroll {
    uint totalSalary;  // 将以前放在calculateRunway中的变量放在这里，成为一个状态变量

    // 需要修改增、删、修改员工的三个函数，更新totalSalary

    function addEmployee(address employeeId, uint salaryOfEther) {
        ... ...
        totalSalary += salaryOfEther;
    }
    
    function removeEmployee(address employeeId) {
        ... ...
        // 我感觉这里的代码有点问题，当只有一个员工时，delete和后面的赋值语句有问题
        delete employees[index]; // 会留下一个空位 
        employees[index] = employees[employees.length-1];
        employees.length -= 1; // 动态数组的length是可以修改的 
        
        // 增加了下面一条语句
        totalSalary -= employee.salary;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (employee, index)= _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        totalSalary -= employee.salary + salary;  // 增加了这一条
        
        employee.salary = salary;
        employee.lastPayday = now;
    }
}







以下是完整的源代码：


contract Payroll {
    // 与C语言类似，可以支持结构类型
    struct Employee {
        address id;  // 这里的ID是个地址 
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees; // 动态数组
    
    uint totalSalary;

   //test steps
   // use the first address to create contract
   // addFund 100 ether, balance = 100 ether
   // add employee "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1
   // add employee "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 1
   // add employee "0x583031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0xdd870fa1b7c4700f2bd7f44238821c26f7392148", 1

   // add employee "0x54723a09acff6d2a60dcdf7aa4aff308fddc160c", 1
   // add employee "0x60897b0513fdc7c541b6d9d7e929c4e5364d2db", 1
   // add employee "0x783031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0x8d870fa1b7c4700f2bd7f44238821c26f7392148", 1
   // add employee "0x983031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0xad870fa1b7c4700f2bd7f44238821c26f7392148", 1

   // use the second address to getPaid, balance = 8 ether


    // 构造函数
    function Payroll() {
        owner = msg.sender;
    }
    
    // 知识点：private
    // 如果不加private，会出现这种奇怪的错误 
    // InternalCompilerError: Static memory load of more than 32 bytes requested.
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    // 查
    // multi return values
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0; i<employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i); // ??? 返回的是一个指针 ？
            }
        }
    }

    // 增A
    // dynimic array use push function
    function addEmployee(address employeeId, uint salaryOfEther) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        employees.push(Employee(employeeId, salaryOfEther * 1 ether, now));
        totalSalary += salaryOfEther;
    }
    
    // 删D
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (employee, index)= _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index]; // 会留下一个空位 
        employees[index] = employees[employees.length-1];
        employees.length -= 1; // 动态数组的length是可以修改的 
        totalSalary -= employee.salary;
    }
    
    // 改U
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (employee, index)= _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        totalSalary -= employee.salary + salary;

        employee.salary = salary;
        employee.lastPayday = now;
    }
    
    // 给合约账户里增加资金
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // 还能支付几次薪水？
    function calculateRunway() returns (uint) {
        require(totalSalary > 0);
/*
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
*/
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        // 支持var变量声明 
        var (employee, index)= _findEmployee(msg.sender);
        require(msg.sender == employee.id);
        
        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
