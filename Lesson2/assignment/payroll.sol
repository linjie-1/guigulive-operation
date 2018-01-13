/*
1.优化前：
添加新员工后调用calculateRunway函数所消耗的gas会随着员工数量增加而增加，优化前每增加一名新员工，调用calculateRunway函数时所消耗的gas大约会增加781gas，具体消耗情况如下：
一名员工：1686 gas；
两名员工：2467 gas；
三名员工：3248 gas；
四名员工：4029 gas；
五名员工：4810 gas；
六名员工：5591 gas；
七名员工：6372 gas；
八名员工：7153 gas；
九名员工：7934 gas；
十名员工：8715 gas；
合计：50005 gas

2.优化后
添加新员工后调用calculateRunway函数所消耗的gas保持不变，不再随着员工数量增加而增加，每次都是852 gas，合计8520 gas，合计减少41485 gas，降低了83%；

3.优化方案
增加 totalSalary 状态变量记录工资总额，并在工资变化点重新计算工资总额，并赋值给 totalSalary（具体包括新增、删除、更新员工三处），同时删除calculateRunway中通过遍历员工数组获取工资总额的方法，改为直接读取totalSalary 状态变量。

4.存在的问题：
从优化 calculateRunway 函数消耗 gas 角度来看，gas 消耗下降较为明显，优化方案是可行的；但与此同时，新增、删除、更新员工三个方法消耗的 gas 却增加了，而且这三个函数也要负担起维护 totalSalary 的职责，维护点从一处变为三处，从可维护性角度来看，现有优化方案并不成功。

5.附录：
addEmployee 函数消耗 gas 记录（记录前3次）：
优化前：82430，68271， 69112
优化后：102663，73504，74345
粗略估算优化后比优化前多消耗 60000 gas（执行10次），比 calculateRunway 函数优化降低的 41485 gas 还要多大概 20000 gas。
*/

pragma solidity ^0.4.19;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    uint totalSalary;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _findEmployee(address employeeId) private returns (Employee storage, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner && employeeId != 0x0 && salary != 0);
        
        var (employee, index) = _findEmployee(employeeId);
        if (employee.id == employeeId) {
            revert();
        }

        employees.push(Employee(employeeId,  salary * 1 ether, now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner && employeeId != 0x0);
        
        uint employeesCount = employees.length;
        var (employee, index) = _findEmployee(employeeId);
        if (employee.id == employeeId) {
            _partialPaid(employee);
                
            delete employees[index];
            employees[index] = employees[employeesCount - 1];
            employees.length = employeesCount - 1;
            
            totalSalary -= employee.salary;
        }
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner && employeeId != 0x0 && salary != 0);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        
        employee.id = employeeId;
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        
        totalSalary = totalSalary - employee.salary + salary;
    }
    
    function getPaid() returns (uint) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
