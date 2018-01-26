<<<<<<< HEAD
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
    uint totalSalary = 0;
  
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0; i<employees.length ;i++) {
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        
        //makesure employee is not exist before add
        assert(employee.id == 0x0);
        uint newSalary = salary * 1 ether;
        employees.push(Employee(employeeId,newSalary,now));
        totalSalary += newSalary;
    }
    
    
    function removeEmployee(address employeeId) {
       require(msg.sender == owner);
       var(employee,index) = _findEmployee(employeeId);
       
       //make sure employee is exist before remove
       assert(employee.id != 0x0);
       
       _partialPaid(employee);
       totalSalary -= employee.salary;
       delete employees[index];
       employees[index] = employees[employees.length - 1];
       employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        uint newSalary = salary * 1 ether;
        totalSalary += newSalary;
        employees[index].salary = newSalary;
        employees[index].lastPayday = now;
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
    
    function getPaid() {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
       
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
=======
/*作业请提交在这个目录下*/
>>>>>>> 6aa23514b6533809de7d0079ed31101390c85f7c
