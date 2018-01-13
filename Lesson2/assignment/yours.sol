/*作业请提交在这个目录下*/
/*
Cache of `total_salary` will reduce the gas cost. 

Gas for `calculateRunway` after calling `addEmpolyee` stays the same (10 times):
transaction cost: 22102 gas;
execution cost: 830 gas;

*/

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint total_salary = 0 ether;
    
    address owner;
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary, now));
        total_salary = total_salary + salary;
    }

    function calculateRunway() returns (uint) {
        return this.balance / total_salary;
    }

}
