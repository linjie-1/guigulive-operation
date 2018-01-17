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
    uint totalSalary = 0;
    
    function Payroll() public  {
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
    
    function addEmployee(address employeeId, uint salary) public {
        requireOwner();
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                revert();
            }
        }
        totalSalary += salary;
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) public {
        requireOwner();
        var (e, index) = _findEmployee(employeeId);
        if (e.id == 0x0) revert();
        _partialPaid(e);
        totalSalary-= e.salary;
        delete employees[index];
        for (uint i = index; i < employees.length; i++) {
            employees[i] = employees[i + 1];
        }
        employees.length--;

    }
    
    function updateEmployee(address employeeId, uint salary) public {
        requireOwner();
        var (e, index) = _findEmployee(employeeId);
        if (e.id == 0x0) revert();
        employees[index].salary = salary;
    }
    
    function addFund() payable  returns(uint)  {
        return this.balance;
    }
    
    
    function calculateRunway() returns(uint) {
       return totalSalary;
    }
    
    function hasEnoughFund() returns(bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid(Employee e) internal {
        requireOwner();
        var nextPayday = e.lastPayday + payDuration;
        assert(nextPayday < now);
        e.lastPayday = nextPayday;
        e.id.transfer(e.salary);
    }
}