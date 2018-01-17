pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    
    address owner;
    mapping(address => Employee) public employees;

    /*
    function Payroll() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    */
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    //第三课作业 使用modifier
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(payDuration);
        employee.id.transfer(payment);        
    }
    
    /*
    function _findEmployee(address employeeId) private constant returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    */
    
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId){ 
        //require(msg.sender == owner);
        //var employee = employees[employeeId];
        //assert(employee.id == 0x0);
        
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);
        totalSalary = totalSalary.add(salary);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        //assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);//优化calculateRunway修改
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        //assert(employee.id != 0x0);        
        
        _partialPaid(employee);

        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayday = now;
    }
    
    //第三课作业 增加changePaymentAddress
    function changePaymentAddress(address employeeId, address newemployeeId) public employeeExist(employeeId) employeeNotExist(newemployeeId) {
        employees[newemployeeId] = employees[employeeId];
        employees[newemployeeId].id = newemployeeId;
        delete employees[employeeId];
    }
    
    /*
    function checkEmployee(address employeeId) public constant returns (uint salary, uint lastPayday){
        var employee= employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    */
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public constant returns (uint) {
        //require(totalSalary != 0);
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        //assert(employee.id != 0x0);  

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;//employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}