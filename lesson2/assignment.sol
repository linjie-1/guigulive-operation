pragma solidity ^ 0.4.14;
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    Employee[] employees;
    function Payroll() {
        owner = msg.sender;
    }
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(payment > 0);
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }
    function _findEmployee(address employeeId) private returns(Employee, uint) {
        assert(employeeId != 0x0);
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
        return (Employee(0x0, 0, 0), 0);
    }
    function requireOwner() private {
        require(msg.sender == owner);
    }
    function addEmployee(address employeeId, uint salary) {
        requireOwner();
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                revert();
            }
        }
        employees.push(Employee(employeeId, salary, now));
    }
    function removeEmployee(address employeeId) {
        requireOwner();
        var (e, index) = _findEmployee(employeeId);
        if (e.id == 0x0) revert();
        _partialPaid(e);
        delete employees[index];
        for (uint i = index; i < employees.length; i++) {
            employees[i] = employees[i + 1];
        }
    }
    function updateEmployee(address employeeId, uint salary) {
        requireOwner();
        var (e, index) = _findEmployee(employeeId);
        if (e.id == 0x0) revert();
        employees[index].salary = salary;
    }
    function addFund() payable returns(uint) {
        return this.balance;
    }
    function calculateRunway() returns(uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    function hasEnoughFund() returns(bool) {
        return calculateRunway() > 0;
    }
    function getPaid(Employee e) {
        requireOwner();
        var nextPayday = e.lastPayday + payDuration;
        assert(nextPayday < now);
        e.lastPayday = nextPayday;
        e.id.transfer(e.salary);
    }
}
