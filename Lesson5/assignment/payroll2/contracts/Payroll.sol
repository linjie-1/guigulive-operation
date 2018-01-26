pragma solidity ^0.4.15;
import './SafeMath.sol';
import './Ownable.sol';
contract Payroll is Ownable {
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping (address => Employee) public employees;
    
    uint public totalSalary; //track the change of totalsalary
    uint public totalEmployee = 0;

    
   
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
     function _partialPaid(Employee employee) private {
            if (employee.id != 0x0) {
                uint salaryTmp = employee.salary * (now - employee.lastPayday) / payDuration;
                employee.id.transfer(salaryTmp);
            }
        }
 
 
    function addEmployee(address employeeId, uint salary) /*onlyOwner employeeNotExist(employeeId)*/{
        
        employees[employeeId] = Employee(employeeId, salary * 1 finney, now);
        totalSalary += salary * 1 finney;
        totalEmployee=totalEmployee.add(1);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {

        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
        totalEmployee=totalEmployee.sub(1);
        return;
           
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){

        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalSalary += salary * 1 finney;
        employees[employeeId].salary = salary * 1 finney;
        employees[employeeId].lastPayday = now;
        return;
          
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
       /* uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
           totalSalary += employees[i].salary;
        }*/
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >= 1;
    }
    
    function checkEmployee(address employeeId) employeeExist(employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        return (employee.salary, employee.lastPayday);
    }
    
    function getPaid() employeeExist(msg.sender) {
        
        var employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayday + payDuration;
        
        assert(nextPayDay <= now );

        uint salaryTmp = employee.salary*((now-employee.lastPayday)/payDuration);
        employees[msg.sender].lastPayday = now;
        employees[msg.sender].id.transfer(salaryTmp);// allow get paid after several duration
    }
    
    function changePaymentAddress(address employeeId, address employeeIdNew) onlyOwner employeeExist(employeeId) employeeNotExist(employeeIdNew){
        var oldEmployee = employees[employeeId];
        
        employees[employeeIdNew] = oldEmployee;
        delete employees[employeeId];
    }
    /*
    function Test() returns (uint){
        addEmployee(1,1);
        addEmployee(2,1);
        addEmployee(3,1);
        addEmployee(4,1);
        addEmployee(5,1);
        addEmployee(6,1);
        addEmployee(7,1);
        addEmployee(8,1);
        addEmployee(9,1);
        addEmployee(10,1);
        return  calculateRunway();
    }*/


    function getEmployeeSalary(address employeeId)  public returns (uint) {
        return employees[employeeId].salary;
    }
    
function getInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance=this.balance;
        runway=calculateRunway();
        employeeCount=totalEmployee;
    }

    function Test3() returns (address) {
        return msg.sender;
    }
}
