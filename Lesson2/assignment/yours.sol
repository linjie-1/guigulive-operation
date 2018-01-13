/*作业请提交在这个目录下*/
// version 1 - Ma Jun #4 @1/12/2018
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
        uint payment = employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i =0; i < employees.length;i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) =  _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary * 1 ether,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return  this.balance / totalSalary ;// display the runway in wei ...Not cool
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday+payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}