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
        uint payment= employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0;i<employees.length;i++){
            if(employees[i].id==employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender ==owner&&employees.length<10);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees.push(Employee(employeeId,salary * 1 ether,now));
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        for(uint index = 0;index<employees.length;index++){
            if(employees[index].id == employeeId){
                _partialPaid(employees[index]);
                totalSalary -= employees[index].salary;
                delete employees[index];
                employees[index] = employees[employees.length-1];
                employees.length -=1;
                return;
            }
        }
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender==owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        totalSalary = totalSalary + salary * 1 ether - employees[index].salary;
        employees[index].salary = salary*1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        assert(totalSalary != 0);
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }

    function getPaid() {
        var(employee, index) = _findEmployee(msg.sender);
        assert(employees[index].id !=0x0);
        uint nextPayday = employee.lastPayday+payDuration;
        assert(nextPayday<now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
