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

    address owner;//0xca35b7d915458ef540ade6068dfe2f44e8fa733c
    mapping (address => Employee) public employees;
    uint totalSalary = 0;

    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
        
    }
    modifier employeeNotExist(address employeeId) {
         var employee = employees[employeeId];
         assert(employee.id == 0x0);
         _;
    }

    function getEmployee(address _employeeAddr) view public returns(uint) {
 
 		return employees[_employeeAddr].salary;
 	}

    function _partialPaid(Employee employee) private {
        
        uint payment = employee.salary
                       .mul(now.sub(employee.lastPayday))
                       .div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
        
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        
        totalSalary -= employees[employeeId].salary;
         delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint newSalary) public onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary = totalSalary - employees[employeeId].salary + newSalary;
        employees[employeeId].salary = newSalary * 1 ether;
        employees[employeeId].lastPayday = now;
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
    
    function checkEmployee(address employeeId) returns (uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
        //return (employee.salary,employee.lastPayday);
        
    }
    
    function getPaid() employeeExist(msg.sender) {
         var employee = employees[msg.sender];
         
         uint nextPayday = employee.lastPayday + payDuration;
         assert(nextPayday < now);
         
         employees[msg.sender].lastPayday = nextPayday;
         employee.id.transfer(employee.salary);
    }
    
    // new changePaymentAddress function here
    // 新加入onlyOwner 
    function changePaymentAddress(address employeeId, address newemployeeId) onlyOwner employeeExist(employeeId) employeeNotExist(newemployeeId) {
         employees[newemployeeId] = employees[employeeId];
         employees[newemployeeId].id = newemployeeId;
         delete employees[employeeId];
     }
}
