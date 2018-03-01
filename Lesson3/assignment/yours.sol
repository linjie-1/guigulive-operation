/*作业请提交在这个目录下*/
pragma solidity ^0.4.14; 
contract Payroll { 
    struct Employee{
        address id;
        uint salary;
        uint lastPayday; 
    }
    uint constant payDuration = 10 seconds; 
    address owner; 
    /*Employee[] employees;*/
    mapping(address => Employee) public employees;
    uint totalSalary = 0;
    function Payroll() { 
        owner = msg.sender; 
    } 
    
    
    function _partialPaid(Employee employee)  private{
        uint payment = employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeID){
        var employee = employees[employeeID];
        assert(employee.id != 0x0);
        _;
    }
    
    
    function addEmployee(address employeeID,uint salary) onlyOwner{
        var employee = employees[employeeID];
        assert(employee.id == 0x0);
        
        employees[employeeID]=Employee(employeeID,salary*1 ether, now);
        totalSalary += salary * 1 ether;                                                                                                                                                                                                                                                                                                                                                                                                                             
    }
    
    function removeEmployee(address employeeID) onlyOwner employeeExist(employeeID){
        var employee = employees[employeeID];
       
        _partialPaid(employee);
        totalSalary -= employees[employeeID].salary;
        delete employees[employeeID];
    }
    
    function updateEmployee(address employeeID, uint salary) onlyOwner employeeExist(employeeID){ 
        var employee = employees[employeeID];
                                                                                                                               
        _partialPaid(employee);
        totalSalary -= employees[employeeID].salary;
        employees[employeeID].salary =salary;
        totalSalary += employees[employeeID].salary;
        employees[employeeID].lastPayday = now;
        
    } 
    
    function checkEmployee(address employeeID) returns (uint salary, uint lastPayday){
        var employee = employees[employeeID];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
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
        employees[msg.sender].lastPayday = nextPayday; 
        employees[msg.sender].id.transfer(employee.salary); 
    } 
    
    function changePaymentAddress(address employeeID,address newEmployeeID) onlyOwner employeeExist(employeeID){
        var employee = employees[employeeID];
        _partialPaid(employee);
        employees[employeeID].id = newEmployeeID;
    }
 } 
 









