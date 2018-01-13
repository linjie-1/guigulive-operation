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
    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private returns (uint) {

        uint paySalary = employee.salary * (now - employee.lastPayday) / payDuration;
        
        require(this.balance >= paySalary * 1 ether);
        employee.id.transfer(paySalary * 1 ether);
        employee.lastPayday = now;
        return paySalary;
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        
        for(uint i = 0; i<employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
        return (Employee(0x0, 0, 0), 123456);
    }

    function addEmployee(address employeeId, uint salary) {
        require(owner == msg.sender);
        totalSalary += salary;
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) {

        require(owner == msg.sender);
        var (employee, index) = _findEmployee(employeeId);
        if (employee.id == 0x0) {
            revert();
        }

        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length--;

        assert(totalSalary >= employee.salary);
        totalSalary -= employee.salary;
    }
    
    function updateEmployee(address employeeId, uint salary) returns (uint, uint) {

        require(owner == msg.sender);
        var (employee, ) = _findEmployee(employeeId);
        if(employee.id == 0x0) {
            revert();
        }

        uint partialSalary = _partialPaid(employee);

        assert(totalSalary >= employee.salary);
        totalSalary -= employee.salary;
        employee.salary = salary;
        totalSalary += salary;

        //monitor partial salary (in ethers)
        //monitor balance (in ethers)
        return (partialSalary, this.balance/1 ether); 
    }
    
    function addFund() payable returns (uint) {

        return this.balance;

    }
    
    function calculateRunway() returns (uint) {

        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        var sender = msg.sender;
        var (employee, ) = _findEmployee(sender);
        if(employee.id == 0x0) {
            revert();
        }

        require(this.balance >= employee.salary * 1 ether);
        employee.lastPayday += payDuration;
        employee.id.transfer(employee.salary * 1 ether);

    }
}
