pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    Employee [] employees;
    uint total_salary = 0 * 1 ether;
    
    function Payroll() {
        owner = msg.sender;
    }

    function _findEmployee(address employeeId) private returns (Employee , uint){
        for(uint i = 0 ; i < employees.length ; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private{
        require(employee.id != 0x0);
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary_in_ether) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary_in_ether * 1 ether, now));
        total_salary += salary_in_ether * 1 ether;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        total_salary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary_in_ether) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        //before upate salary update total_salary
        total_salary -= employees[index].salary;
        employees[index].salary = salary_in_ether * 1 ether;
        //add total_salary
        total_salary += salary_in_ether * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        //require at least total_salary > 0
        require(total_salary > 0);
        return this.balance / total_salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employees[index].lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
        
    }
}
