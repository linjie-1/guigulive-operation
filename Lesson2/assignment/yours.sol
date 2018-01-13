pragma solidity ^0.4.14;

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
        require(employee.id != 0x0);
        
        employee.id.transfer(employee.salary * (now - employee.lastPayday)/payDuration);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        var (emp, index) = _findEmployee(employeeId);
        require(emp.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        var (emp, index) = _findEmployee(employeeId);
        require(emp.id != 0x0);
        
        _partialPaid(emp);
        totalSalary -= emp.salary;
        employees[index] = employees[employees.length-1];
        delete employees[employees.length-1];
        employees.length--;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        var (emp, index) = _findEmployee(employeeId);
        require(emp.id != 0x0);
        
        _partialPaid(emp);
        totalSalary -= emp.salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += employees[index].salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (totalSalary > 0) {
            return this.balance / totalSalary;
        }
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (emp, index) = _findEmployee(msg.sender);
        require(emp.id != 0x0);
        if (this.balance > emp.salary && now > emp.lastPayday + payDuration) {
            employees[index].lastPayday = now;
            emp.id.transfer(emp.salary);
        }
    }
}
