pragma solidity ^0.4.14;

contract Payroll{
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;

    Employee [] employees;
    address owner;
    uint _totalSalary = 0;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeID) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeID){
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeID, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeID, salary * 1 ether, now));
        _totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeID){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        _totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeID, uint salary){
        require (msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        _totalSalary -= employees[index].salary;
        _totalSalary += salary * 1 ether;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable returns (uint){
        return this.balance;
    }

    function calculateRunway() returns (uint){
        return this.balance / _totalSalary;
    }

    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0 ;
    }

    function getPaid(){
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert (nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}

