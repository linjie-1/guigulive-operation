pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) public employees;
    uint total_salary = 0 * 1 ether;
    
    function Payroll() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private{
        require(employee.id != 0x0);
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary_in_ether) 
    public onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary_in_ether * 1 ether, now);
        total_salary += salary_in_ether * 1 ether;
    }
    
    function removeEmployee(address employeeId) 
    public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        total_salary -= employee.salary;
        _partialPaid(employee);
        delete employees[employeeId];
        
    }
    
    function changePaymentAddressByOwner(address oldId, address newId) 
    public onlyOwner employeeExist(oldId) {
        var employee = employees[oldId];
        var newEmployee = Employee(newId, employee.salary, employee.lastPayday);
        employees[newId] = newEmployee;
        delete employees[oldId];
    }
    
    function changePaymentAddressByEmployee(address newId) 
    public employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        var newEmployee = Employee(newId, employee.salary, employee.lastPayday);
        employees[newId] = newEmployee;
        delete employees[msg.sender];
    }
    
    function updateEmployee(address employeeId, uint salary) 
    public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        total_salary -= employee.salary;
        employees[employeeId].salary = salary;
        total_salary += salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance / total_salary;
    }
    
    function checkEmployee(address employeeId) 
    public returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        //return (employee.salary, employee.lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function hasEnoughFund() 
    public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() 
    public{
        var employee= employees[msg.sender];
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employee.salary);
        
    }
}
