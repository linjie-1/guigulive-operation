//#39_王博远 第二次作业
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;//0xca35b7d915458ef540ade6068dfe2f44e8fa733c
    Employee[] employees;
    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
        totalSalary = 0;
        
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0;i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        
        totalSalary -= employees[index].salary;
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length--;

    }
    
    function updateEmployee(address employeeId, uint newSalary) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary = totalSalary - employees[index].salary + newSalary * 1 ether;
        employees[index].salary = newSalary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {   
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return this.calculateRunway() > 0;
    }
    
    function getPaid() {
         var(employee,index) = _findEmployee(msg.sender);
         assert(employee.id != 0x0);
         
         uint nextPayday = employee.lastPayday + payDuration;
         assert(nextPayday < now);
         
         employees[index].lastPayday = nextPayday;
         employee.id.transfer(employee.salary);
    }
}
