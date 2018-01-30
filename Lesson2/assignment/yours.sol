/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
//因为每次都要循环遍历的缘故，没加一次雇员，需要更多的gas，所以我把totalSalary的运算放在其他会改动totalSalary的函数，以降低gas的消耗
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;

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
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary = totalSalary + salary;
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        totalSalary = totalSalary - employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);       
        _partialPaid(employee);
        totalSalary = totalSalary + salary - employee.salary;
        employee.salary = salary;
        employee.lastPayday = now;
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
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
