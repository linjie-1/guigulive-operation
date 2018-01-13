/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    uint totalSalary;

    address owner;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }

    Employee[] employees;

    function Payroll() public{
        owner = msg.sender;
    }

    function _findEmployee(address e) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == e){
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        // when no employee is found, does _findEmployee return empty values?
        assert(employee.id == 0x0);
        employees.push(Employee(e, s * 1 ether, now));
        totalSalary += s;
    }

    function removeEmployee(address e) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employees[index].salary = s * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += s;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint){
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public{
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}