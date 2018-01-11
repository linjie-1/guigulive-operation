pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;  //for new calculateRunway function
    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0; i< employees.length; i++){
            if (employees[i].id == employeeId)
                return (employees[i], i);
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint salaryInWei = salary * 1 ether;
        employees.push(Employee(employeeId, salaryInWei, now));
        totalSalary += salaryInWei;
    }
    
    function removeEmployee(address employeeId) {
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
        totalSalary -= employee.salary;
        assert(employee.id != 0x0);
        _partialPaid(employee);
        uint salaryInWei = salary * 1 ether;
        employees[index].id = employeeId;
        employees[index].salary = salaryInWei;
        totalSalary += salaryInWei;
        
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint _totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            _totalSalary += employees[i].salary;
        }
        return this.balance / _totalSalary;
    }
    
    function calculateRunwayNew() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
            
        uint nextPayday = employee.lastPayday + payDuration;
        if (nextPayday > now)
            revert();
            
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

/*
统计N个员工时，消耗的gas数

N  Gas
1  1694
2  2475
3  3256
4  4037
5  4818
6  5599
7  6380
8  7161
9  7942
10 8723
gas大致呈线性增长
原因：calculateRunway需要遍历每个员工，计算总工资

优化思路：增加一个变量专门用于记录总工资，在员工变动时修改这个变量，
避免每次都遍历所有员工
如calculateRunwayNew函数所示

优化后的gas消耗恒定为896，与人数无关

另一方面，由于增加了总工资计算处理，addEmployee等函数gas值有所增加。
但考虑实际应用中addEmployee，updateEmployee函数的调用远少于calculateRunway，
这个变化还是可以接受的

*/


