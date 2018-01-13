pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address owner;
    uint constant payDuration = 10 seconds;
    // define totalSalary here
    uint totalSalary;

    Employee[] employees;

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

        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;

        totalSalary -= employee.salary;
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
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        require(totalSalary > 0);

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
        assert(this.balance > employee.salary);

        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}