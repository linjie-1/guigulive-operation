pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;  //for new calculateRunway function
    address owner;
    mapping (address => Employee) public employees;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId){
        assert(employees[employeeId].id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        assert(employees[employeeId].id == 0x0);
        _;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        uint salaryInWei = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salaryInWei, now);
        totalSalary += salaryInWei;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, address employeeIdNew, uint salary) onlyOwner employeeExist(employeeId) {
        removeEmployee(employeeId);
        addEmployee(employeeIdNew, salary);
    }
    
    function changePaymentAddress(address employeeNewAddress) employeeExist(msg.sender)  employeeNotExist(employeeNewAddress){
        var employee = employees[msg.sender];
        employees[employeeNewAddress] = Employee(employeeNewAddress, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
            
        uint nextPayday = employee.lastPayday + payDuration;
        if (nextPayday > now)
            revert();
            
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

