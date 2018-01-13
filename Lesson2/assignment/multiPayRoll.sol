/*第二节课作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
*/

优化前calculateRunway函数执行gas消耗量如下,每增加一个人gas消耗量增加781，原因是在计算totalSalary时候涉及到for循环，其循环次数等于员工人数，即employees数组的长度。

一名员工：3911 gas
两名员工：4692 gas
三名员工：5473 gas
四名员工：6254 gas
五名员工：7035 gas
六名员工：7816 gas
七名员工：8597 gas
八名员工：9378 gas
九名员工：10159 gas
十名员工：10940 gas

优化方法即将totalSalary作为local variable，每add一个员工或者update一个员工的salary，则更新totalSalary的值。优化后calculateRunway函数执行gas消耗量如下：

一名员工：3069 gas
两名员工：3069 gas
三名员工：3069 gas
四名员工：3069 gas
五名员工：3069 gas
六名员工：3069 gas
七名员工：3069 gas
八名员工：3069 gas
九名员工：3069 gas
十名员工：3069 gas

优化后代码：

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    
    
    uint totalSalary = 0;
    
    // dynamical array
    Employee[] employees;

    // consturct function
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint)  {
        for (uint i; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint s) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint salary = s * 1 ether;
        employees.push(Employee(employeeId,salary,now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += employees[index].salary;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employees[index].lastPayday = now;
        msg.sender.transfer(employee.salary);
    }
}

优化前代码：

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    
    // dynamical array
    Employee[] employees;

    // consturct function
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint)  {
        for (uint i; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint s) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint salary = s * 1 ether;
        employees.push(Employee(employeeId,salary,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].id = employeeId;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employees[index].lastPayday = now;
        msg.sender.transfer(employee.salary);
    }
}