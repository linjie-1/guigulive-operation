pragma solidity ^0.4.18;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;//(in wei)
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    address owner;
    mapping(address=>Employee) public employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner{
        
     require(msg.sender==owner);
    _;
        
    }
    
    modifier employeeExists(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id!=0x0);
        _;
    }
    
        modifier employeeDoesntExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id==0x0);
        _;
    }

    function getEmployeeSalary(address employeeId) employeeExists(employeeId) returns (uint) {
        return employees[employeeId].salary/(1 ether);
    }
    
    function _partialPaid(Employee employee) private {
        uint amount = employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(amount);
    }
    
    function addEmployee(address employeeId, uint salaryInEther) onlyOwner employeeDoesntExist(employeeId)  {
        employees[employeeId]=Employee(employeeId, salaryInEther*1 ether, now);
        totalSalary+=salaryInEther*1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId){
        totalSalary-=employees[employeeId].salary;
        _partialPaid(employees[employeeId]);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salaryInEther) onlyOwner employeeExists(employeeId) {
        totalSalary-= employees[employeeId].salary;//update totalSalary
        _partialPaid(employees[employeeId]);
        employees[employeeId].salary=salaryInEther*1 ether;
        totalSalary+=employees[employeeId].salary;//update totalSalary
        employees[employeeId].lastPayday=now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function changePaymentAddress(address oldId, address newId) onlyOwner employeeExists(oldId) employeeDoesntExist(newId){
        employees[newId]=Employee(newId, employees[oldId].salary, employees[oldId].lastPayday);
        delete employees[oldId];
    }
    
    function getPaid() employeeExists(msg.sender) {
        uint nextPayday = employees[msg.sender].lastPayday+payDuration;
        assert(nextPayday<now);
        employees[msg.sender].lastPayday=nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
        
    }
    

}