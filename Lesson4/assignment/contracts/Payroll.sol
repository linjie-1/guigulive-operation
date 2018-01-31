<<<<<<< HEAD
pragma solidity ^0.4.18;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

=======
pragma solidity ^0.4.14;

contract Payroll {
>>>>>>> master
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
<<<<<<< HEAD

    uint public constant payDuration = 10 seconds;

    mapping (address => Employee) public employees;
    uint public totalSalary;

    modifier employeeExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeId) {
        require(employeeId != 0x0);
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function addEmployee(
        address employeeId,
        uint salary
    ) onlyOwner employeeNotExist(employeeId) external {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function removeEmployee(
        address employeeId
    ) onlyOwner employeeExist(employeeId) external {
        Employee storage employee = employees[employeeId];
        uint payment = _calculatePartialPayment(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        employeeId.transfer(payment);
    }

    function updateEmployee(
        address employeeId,
        uint salary
    ) onlyOwner employeeExist(employeeId) external {
        Employee storage employee = employees[employeeId];
        uint payment = _calculatePartialPayment(employee);
        totalSalary = totalSalary.sub(employee.salary);

        employee.salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employee.salary);

        employee.lastPayday = now;
        employeeId.transfer(payment);
    }

    function addFund() external payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() external view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) external {
        Employee storage employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function changePaymentAddress(
        address employeeId
    ) employeeExist(msg.sender) employeeNotExist(employeeId) external {
        employees[employeeId] = Employee(
            employeeId,
            employees[msg.sender].salary,
            employees[msg.sender].lastPayday
        );

        delete employees[msg.sender];
    }

    function _calculatePartialPayment(Employee employee) private view returns (uint) {
        uint workDuration = now.sub(employee.lastPayday);
        return employee.salary.mul(workDuration).div(payDuration);
    }
=======
    
    uint constant payDuration = 10 seconds;
    
    uint totalSalary;
    address owner;
    mapping(address => Employee) public employees;

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
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
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
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
>>>>>>> master
}
