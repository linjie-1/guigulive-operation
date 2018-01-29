
// version 1 4-马骏-第三次作业
// @ 1/17/2018
pragma solidity ^0.4.14;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{// iheritance here 
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint public totalSalary ; // state variable

    address owner;
    mapping( address => Employee) public employees;

 //   function Payroll() {
//        owner = msg.sender;
//    }
    
//    modifier onlyOwner{
//        require(msg.sender == owner);
//        _;
//    }
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    

    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        //require(msg.sender == owner);
        var employee =  employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId]= Employee(employeeId, salary * 1 ether, now);
        totalSalary += employees[employeeId].salary;
        
    }
    
    function removeEmployee(address employeeId) onlyOwner  employeeExist(employeeId){
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        //assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];

    }
    
    modifier changeAddress(address employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        _;
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) changeAddress(employeeId){
        //require(msg.sender == owner);
        //var employee = employees[employeeId];
        //assert(employee.id != 0x0);
        
        //_partialPaid(employee);
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address employeeId, address newAddress)onlyOwner employeeExist(employeeId) changeAddress(newAddress){
        //var employee = employees[newAddress];
        //_partialPaid(employee);
        employees[employeeId].lastPayday = now;    
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        //uint totalSalary = 0;

        return  this.balance / totalSalary ;// display the runway in wei ...Not cool
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        //assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday+payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}