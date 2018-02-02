pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary;
    uint totalEmployee;

    address owner;
    mapping(address => Employee) public employees; //Mapping

    function Payroll() public {
        owner = msg.sender;
    }

    // custom modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    // modifier with parameter
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
     // modifier with parameter
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) public {
        totalSalary += salary * 1 ether;
        totalEmployee += 1;
        employees[employeeId] = Employee(employeeId, salary, now);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalEmployee -= 1;
        delete employees[employeeId];
    }

    function findEmployee(address employeeId) employeeExist(employeeId) public returns (Employee){
        return employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalSalary += salary * 1 ether; // Don't forget the unit
        employee.salary = salary;
        employee.lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint) {
        assert(totalSalary != 0x0);
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        if (totalSalary == 0x0) {
            return true;
        }
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) public returns (uint salary, uint lastPayday) { //return parameters naming
        var employee = employees[employeeId];
        //return (employee.salary, employee.lastPayday);
        // return parameters assignment
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    function getPaid() employeeExist(msg.sender) public {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    // new method
    function changePaymentAddress(address newAddress) employeeExist(msg.sender) employeeNotExist(newAddress) public {
        var employee = employees[msg.sender];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }

    function checkInfo() public returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        runway = calculateRunway();
        employeeCount = totalEmployee;
    }
}
