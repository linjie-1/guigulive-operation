pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint totalSalary = 0 * 1 ether;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        require(employee.id != 0x0);
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

    function addEmployee(address employeeId, uint s) {
        require(msg.sender == owner);
        var(employee, idx) = _findEmployee(employeeId);
        
        // make sure it is new employee
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, s * 1 ether, now));
        totalSalary += s * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var(employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[idx]);
        
        totalSalary -= employees[idx].salary;
        delete employees[idx];
        employees[idx] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint s) {
        require(msg.sender == owner);
        
        var(employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[idx]);
        
        totalSalary -= employees[idx].salary;
        employees[idx].salary = s * 1 ether;
        employees[idx].lastPayday = now;
        totalSalary += s * 1 ether;
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
        // this function can be called by either of the employees
        // pay the employee call this function
        
        var (employee, idx) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[idx].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);        
    }
}
