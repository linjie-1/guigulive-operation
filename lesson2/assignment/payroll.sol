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

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary__ether) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary__ether * 1 ether, now));

    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary__ether) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        employees[index].id = employeeId;
        employees[index].salary = salary__ether * 1 ether;
    }
    
    function addFund() payable returns (uint) {
    }
    
    function getAllSalary(uint i) private returns (uint){
            return employees[i].salary + ( i>0 ? getAllSalary(i-1) : 0);
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        return this.balance / getAllSalary(employees.length-1);
    }
    
    function hasEnoughFund() returns (bool) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        return this.balance > employee.salary;
    }
    
    function getPaid() returns (uint) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }
}
