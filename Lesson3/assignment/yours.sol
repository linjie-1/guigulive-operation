/*作业请提交在这个目录下*/

pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable  {
    
    struct Employee{
        address id ;
        uint salary;
        uint lastPayday;
    }
    
    mapping(address => Employee) public employees;
    address owner;
    uint constant payDuration = 10 seconds;
    uint  totalSalary;
    using SafeMath for uint256;
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
        
    }

    modifier notOwner(){
        
        
        
    }
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary.mul((now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }
    
    function checkEmployee(address employeeId) returns(uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner  {
        
        var employee = employees[employeeId];
        employees[employeeId] = Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(employee.salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary) ;
        delete  employees[employeeId];

    }
    
    function updateEmployee(address employeeId ,uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;

    }
    
    function calculateRunway( ) returns (uint){
        return this.balance.div(totalSalary);
        
    }

   // add fund into the account
    function addFund() payable returns(uint) {
        return  this.balance;
    }
    
    function hasEnoughFund() returns (bool){
        return  calculateRunway()> 0;
        
    }
  
    function changePaymentAddress(address employeeId) employeeExist(msg.sender){
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId,employee.salary,employee.lastPayday);
        delete employees[msg.sender];
    }   
    
    // the staff claim his salary
    function getPaid() employeeExist(msg.sender) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now) ;
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
       
   }
   

  
}
