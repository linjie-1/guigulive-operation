/*作业请提交在这个目录下*/

/*
优化前的代码
*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++)
        {
            if(employeeId == employees[i].id)
            {
                return (employees[i], i);
            } 
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        delete employees[index];
        if(employees.length > 1)
            employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayDay = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);
        
        employees[index].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}

/*
优化代码版本1
思路：将数组长度(employees.length)赋给临时变量(employeesCount),避免多次取长度
*/
function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        uint employeesCount = employees.length;
        for (uint i = 0; i < employeesCount; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    
/*
优化代码版本2
思路：将计算totalSalary值作为一个类的成员变量，在增删改员工信息的时候，就更新做加减。避免多次调用calculateRunway时重复计算
*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    Employee[] employees;
    uint totalSalary = 0;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++)
        {
            if(employeeId == employees[i].id)
            {
                return (employees[i], i);
            } 
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        salary = salary * 1 ether;
        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        delete employees[index];
        totalSalary -= employee.salary;
        if(employees.length > 1)
            employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        uint oldSalary = employees[index].salary;
        uint newSalary = salary * 1 ether;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayDay = now;
        totalSalary += newSalary - oldSalary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);
        
        employees[index].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}



/*
优化前后的对比
三个数值（execution cost ）分别是：
优化前的代码 - 优化代码版本1 - 优化代码版本2
优化版本1:编码习惯的上注意一下就可以，明显就能节省不少cost
优化版本2:虽然在增删改的时候会增加cost，但相比而言calculateRunway的调用次数更加频繁，整体上降低了比较大的cost
*/
"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1
1694 - 1499 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1622",1
2475 - 2072 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1633",1
3256 - 2645  - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1644",1
4037 - 3218 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1655",1
4818 - 3791 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1666",1
5599 - 4364 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1677",1
6380 - 4937 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1688",1
7161 - 5510 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1699",1
7942 - 6083 - 852

"0x14723a09acff6d2a60dcdf7aa4aff308fddc1611",1
8723 - 6656 - 852
