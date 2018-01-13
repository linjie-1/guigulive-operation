pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    address owner;
    Employee [] employees;
    uint current_totalSalary = 0;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index)  = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint salary_new = salary * 1 ether;
        employees.push(Employee(employeeId, salary_new, now));
        current_totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index)  = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        current_totalSalary -= employees[index].salary * 1 ether;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;

    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index)  = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        current_totalSalary += salary * 1 ether - employees[index].salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        //uint totalSalary = 0;
       //for (uint i = 0; i < employees.length; i++) {
       //     totalSalary += employees[i].salary;
       // }
        return this.balance / current_totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index)  = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
