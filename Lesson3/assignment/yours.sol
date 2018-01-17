
pragma solidity ^0.4.14;


import './SafeMath.sol';
import './Ownable.sol';
contract Payroll {
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint private totalSalary = 0;
    address owner;
    mapping(address => Employee) public employees;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        totalSalary -= employee.salary;
        delete employees[employeeId];
        
        
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary + salary * 1 ether;

        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
    }
    
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner employeeExist(oldEmployeeId){
        var employee = employees[oldEmployeeId];
        var newEmployee = Employee(newEmployeeId, employee.salary, employee.lastPayday);
        
        delete employees[oldEmployeeId];
        employees[newEmployeeId] = newEmployee;
        
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
    
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
