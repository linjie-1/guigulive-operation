/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
<<<<<<< HEAD

=======
//因为每次都要循环遍历的缘故，没加一次雇员，需要更多的gas，所以我把totalSalary的运算放在其他会改动totalSalary的函数，以降低gas的消耗
>>>>>>> master
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
<<<<<<< HEAD
    
=======
>>>>>>> master
    uint totalSalary;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
<<<<<<< HEAD
        totalSalary = 0 ether;
=======
>>>>>>> master
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
<<<<<<< HEAD
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
=======
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
>>>>>>> master
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
<<<<<<< HEAD
        require(employeeId != 0x0 && salary > 0);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
=======
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary = totalSalary + salary;
        employees.push(Employee(employeeId, salary, now));
>>>>>>> master
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
<<<<<<< HEAD
        require(employeeId != 0x0);
        
        var (employee,index) = _findEmployee(employeeId);
        assert (employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        totalSalary -= employee.salary;
        employees[index]= employees[--employees.length];
=======
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        totalSalary = totalSalary - employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        
>>>>>>> master
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
<<<<<<< HEAD
        require(employeeId != 0x0 && salary > 0);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary = totalSalary - employee.salary + salary * 1 ether;
        employees[index].lastPayday= now;
        employees[index].salary = salary * 1 ether;
=======
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);       
        _partialPaid(employee);
        totalSalary = totalSalary + salary - employee.salary;
        employee.salary = salary;
        employee.lastPayday = now;
>>>>>>> master
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
<<<<<<< HEAD
    	assert(totalSalary > 0);
=======
>>>>>>> master
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
<<<<<<< HEAD
        assert(employee.lastPayday + payDuration < now && this.balance > employee.salary);
        employees[index].lastPayday = now;
=======
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
>>>>>>> master
        employee.id.transfer(employee.salary);
    }
}
