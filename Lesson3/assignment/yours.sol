pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address=>Employee) employees;
    uint totalSalary = 0;
    

    
    
  
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        
        //makesure employee is not exist before add
        assert(employee.id == 0x0);
        uint newSalary = salary * 1 ether;
        employees[employeeId] = Employee(employeeId,newSalary,now);
        totalSalary += newSalary;
    }
    
    
    function removeEmployee(address employeeId) {
       require(msg.sender == owner);
       var employee = employees[employeeId];
       
       //make sure employee is exist before remove
       assert(employee.id != 0x0);
       
       _partialPaid(employee);
       totalSalary -= employee.salary;
       delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        uint newSalary = salary * 1 ether;
        totalSalary += newSalary;
        employees[employeeId].salary = newSalary;
        employees[employeeId].lastPayday = now;
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
    
    function checkEmployee(address  employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        
        //return (employee.salary, employee.lastPayday);
        //OR
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
       
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
