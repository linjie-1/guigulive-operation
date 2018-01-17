/*作业请提交在这个目录下*/

//q1

pragma solidity ^0.4.14;

contract payRoll{
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint totalSalary;
    mapping(address => Employee) employees;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = (Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        
        assert(employee.id == 0x0);
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        
        assert(employee.id == 0x0);
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary += employees[employeeId].salary;
        
    }
    
    function addFund() returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function checckEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id == 0x0);
        
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}


/// q2
function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
  var employee = employees[employeeId];
  
  _partialPaid(employee);
  employees[employeeId].id = newEmployeeId;
  employees[newEmployeeId].lastPayday = now;
}
