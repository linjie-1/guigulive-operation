/*作业请提交在这个目录下*/
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

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));

    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        employees[index].id = employeeId;
        employees[index].salary = salary * 1 ether;
    }
    
    function addFund() payable returns (uint) {
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        //Employee[] memory _employees  = employees;
        //for (uint i = 0; i < _employees.length; i++) {
        //    totalSalary += _employees[i].salary;
        //}
        uint _length = employees.length;
        uint _salary = 0;
        for( uint i =0; i< _length; i++){
            totalSalary = employees[i].salary + totalSalary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        return this.balance > employee.salary;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }
}
