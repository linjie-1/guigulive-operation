pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
        
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    mapping(address => Employee) public employees;
    uint totalSalary;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addEmployee(address employeeId, uint numOfEthers) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint salary = numOfEthers * 1 ether;
        totalSalary += salary;
        
        employees[employeeId] = Employee(employeeId, salary, now);
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        _partialPaid(employees[employeeId]);

        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint numOfEthers) public onlyOwner employeeExist(employeeId) {
        totalSalary -= employees[employeeId].salary;
        _partialPaid(employees[employeeId]);
        employees[employeeId].salary = numOfEthers * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() public onlyOwner payable returns (uint)  {
        return this.balance;
    }
    
    function getPayDuration() returns (uint) {
        return payDuration;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; // In EVM it's jump operation; if use this.calculateRunway() will use msg, gas cost is high 
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
