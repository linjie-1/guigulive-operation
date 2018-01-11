添加新员工后调用calculateRunway函数所消耗的gas会随着员工数量增加而增加，优化前每增加一名新员工，调用calculateRunway函数时所消耗的gas大约会增加781gas，具体消耗情况如下：
一名员工：1716gas;
两名员工：2497gas;
三名员工：3278gas;
四名员工：4059gas;
五名员工：4840gas;
六名员工：5621gas;
七名员工：6402gas;
八名员工：7183gas;
九名员工：7964gas;
十名员工：8745gas;
合计：52305gas;

优化后gas消耗情况：
一名员工：1521gas;
两名员工：2049gas;
三名员工：2667gas;
四名员工：3240gas;
五名员工：3814gas;
六名员工：4386gas;
七名员工：4959gas;
八名员工：5532gas;
九名员工：6150gas;
十名员工：6678gas;
合计：40987gas;

原因分析：
1. 添加员工，employees数组长度变长，calculateRunway函数中for循环迭代消耗的gas与上一次调用时相比有所增加。
2. calculateRunway函数中for循环，以employees.length方式获取employees数组长度，比预先获取employees数组长度后在for循环中直接使用此数组长度值消耗的gas要高；
即for (uint i = 0; i < employees.length; i++)语句消耗的gas要高于for (uint i = 0; i < 4; i++)语句消耗的gas。 

优化思路：
1. 在totalSalary发生变更的地方(添加、修改、删除员工函数)进行修改，在calculateRunway中采用已有totalSalary进行计算；
优点：calculateRunway函数消耗的gas会大幅度减少；
缺点：
1).增加代码逻辑复杂度，可读性变差；
2).增加代码维护成本(并不是所有维护者都清楚这里的逻辑，若后期有其他相关函数引发totalSalary发生变更，这个逻辑可能会被遗漏)，另外调用这些函数时会也增加gas消耗。

2. 只在使用totalSalary的地方进行处理，calculateRunway函数中，定义局部变量存储employees.length，依然通过for循环计算totalSalary。
优点：代码逻辑清晰，易于维护;
缺点：以添加10名员工测试，优化后消耗gas为优化前的78%(优化后gas消耗总量:40987，优化前gas消耗总量:52305)，降低幅度不是特别明显；

总结：从代码清晰度与可维护性方面考虑，我采用第二种优化方案。

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    
    Employee []employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialFindEmployee(address employeeId) private returns (Employee, uint) {
        uint len = employees.length;
        for (uint i = 0; i < len; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var(employee, _) = _partialFindEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);
        
        // 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        uint len = employees.length;
        delete employees[index];
        employees[index] = employees[len - 1];
        len--;
    }
    
    function updateSalary(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);
        
        uint newSalary = salary * 1 ether;
        assert(newSalary != employee.salary);
        
        // 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        employees[index].salary     = newSalary;
        employees[index].lastPayDay = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        uint len         = employees.length;
        for (uint i = 0; i < len; i++) {
            totalSalary += employees[i].salary;
        }
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _partialFindEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);
        
        employees[index].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
