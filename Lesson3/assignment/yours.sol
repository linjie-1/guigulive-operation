/*
C3 Linearization Problem:
contract O
=> O
contract A is O
=> A + merge(L[O], [O])
   A + merge([O], [O])
   [A, O]
contract B is O
=> [B, O]
contract C is O
=> [C, O]
contract K1 is A, B
=> K1 + merge(L[B], L[A], [B, A])
   K1 + merge([B, O], [A, O], [B, A])
   [K1, B, A, O]
contract K2 is A, C
=> [K2, C, A, O]
contract Z is K1, K2
=> Z + merge(L[K2], L[K1], [K2, K1])
   Z + merge([K2, C, A, O], [K1, B, A, O], [K2, K1])
   [Z, K2] + merge([C, A, O], [K1, B, A, O], [K1])
   [Z, K2, C] + merge([A, O], [K1, B, A, O])
   [Z, K2, C, K1, B, A, O]
*/

pragma solidity ^0.4.14;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Payroll is Ownable{
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary;

    mapping(address => Employee) public employees;

    modifier onlyEmployee {
        Employee employee = employees[msg.sender];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeExists(address employeeId) {
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint partialPayment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        assert(this.balance >= partialPayment);

        employee.lastPayday = now;
        employee.id.transfer(partialPayment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);

        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);

        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);

        uint newSalary = salary.mul(1 ether);
        totalSalary = totalSalary.add(newSalary).sub(employee.salary);
        employees[employeeId].salary = newSalary;
    }

    function changeEmployeeAddress(address newEmployeeId) onlyEmployee {
        Employee employee = employees[msg.sender];

        employee.id = newEmployeeId;
        employees[newEmployeeId] = employee;
        delete employees[msg.sender];
    }

    function addFund() payable returns (uint) {
        require(msg.sender == owner);

        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() onlyEmployee returns (Employee) {
        Employee employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        assert(this.balance >= employee.salary);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
