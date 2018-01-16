pragma solidity ^0.4.14;

// 在优化前，每次gas都不一样，因为每次循环中找到该雇员都不是固定好的次数。
// 优化好后的代码如下：通过创立 uint totalSalary，我们可以把每次计算calculateRunway大幅度降低至小于优化前数值的一个固定值

// after optimization, the transaction and execution costs are listed below and they are constant
// 22124, 852

// the transaction and execution costs are listed below for all 10 unoptimized program
// 22966, 1694
// 23747, 2475
// 24528, 3256
// 25309, 4037
// 26090, 4818
// 22912, 3012
// 26030, 4910
// 29378, 1989
// 29989, 3982
// 27767, 2938

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint totalSalary = 0;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return(employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) payable{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        totalSalary -= employee.salary;
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) payable{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employee.salary = salary;
        employee.lastPayday = now;
        totalSalary += salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
    //     uint totalSalary = 0;
    //   for (uint i = 0; i < employees.length; i++) {
    //         totalSalary += employees[i].salary;
    //     }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() payable {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);        
    }
}

