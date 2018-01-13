//今天还得上班，明天写完
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
    uint totalSalary;//优化calculateRunway修改

    function Payroll() public {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);        
    }
    
    function _findEmployee(address employeeId) private constant returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary) public { 

    }
    
    function removeEmployee(address employeeId) public {

    }

    function updateEmployee(address employeeId, uint salary) public {
        
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    

    function calculateRunway() public constant returns (uint) {
        require(totalSalary != 0);
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {

    }
}
