// gas 消耗记录表格见 ./gasChangeRecord.md

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
                return (employees[i], i);
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
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        totalSalary -= employees[index].salary;

    }
    
    function ownerUpdateEmployee(address employeeId, uint newSalary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary = totalSalary - employees[index].salary + newSalary; 
        employees[index].salary = newSalary;
        employees[index].lastPayday = now;
    }
    
    function addMoney() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        assert(totalSalary != 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughMoney() returns (bool) {
        return calculateRunway() > 1;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint shouldPayday = employee.lastPayday + payDuration;
        assert(shouldPayday < now);
        
        employees[index].lastPayday = shouldPayday;
        employee.id.transfer(employee.salary);
    }
}
