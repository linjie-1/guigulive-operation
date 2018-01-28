pragma solidity ^0.4.14;

import './Ownable.sol';

contract Payroll is Ownable{
  struct Employee {
    address addr;
    address paymentAddr;
    uint salary;
    uint lastPayday;
  }

  uint constant payDuration = 10 seconds;
  uint totalSalary = 0;
  address owner;
  uint constant UINT256_MAX = ~uint(0);

  mapping(address => Employee) employees;

  modifier validEmployee() {
    var employee = employees[msg.sender];
    require(employee.addr != 0x0);
    _;
  }

  modifier validSalary(uint salary) {
    require(salary > 0);
    _;
  }

  function _partialPaid(Employee employee) private {
    uint amount = employee.salary * (now - employee.lastPayday) / payDuration;
    employee.paymentAddr.transfer(amount);
  }

  function addEmployee(address employeeAddr, uint salary) public onlyOwner validSalary(salary) {
    var duplicate = employees[employeeAddr];
    assert(duplicate.addr == 0x0);
    totalSalary += salary * 1 ether;
    employees[employeeAddr] = Employee(employeeAddr, employeeAddr, salary * 1 ether, now);
  }

  function removeEmployee(address employeeAddr) public onlyOwner {
    var employee = employees[employeeAddr];
    assert(employee.addr != 0x0);

    _partialPaid(employee);
    totalSalary -= employee.salary;
    delete employees[employeeAddr];
  }

  function updateEmployee(address employeeAddr, uint salary) public onlyOwner validSalary(salary) {
    var employee = employees[employeeAddr];
    assert(employee.addr != 0x0);

    _partialPaid(employee);
    totalSalary += salary * 1 ether - employee.salary;
    employees[employeeAddr].salary = salary * 1 ether;
    employees[employeeAddr].lastPayday = now;
  }

  function changePaymentAddr(address paymentAddr) public validEmployee {
      var employee = employees[msg.sender];
      employee.paymentAddr = paymentAddr;
  }

  function checkEmployee(address employeeAddr) public view returns (uint salary, uint lastPayday) {
    var employee = employees[employeeAddr];
    return (employee.salary, employee.lastPayday);
  }

  function addFund() public payable returns (uint balance) {
    return this.balance;
  }

  function calculateRunway() public view returns (uint runway) {
    if (totalSalary == 0) {
        if (this.balance == 0) {
            return 0;
        } else {
            return UINT256_MAX;
        }
    }
    return this.balance / totalSalary;
  }

  function hasEnoughFund() public view returns (bool) {
    return calculateRunway() > 0;
  }

  function getPaid() public validEmployee {
    var employee = employees[msg.sender];
    uint nextPayday = employee.lastPayday + payDuration;
    assert(nextPayday < now);

    employees[msg.sender].lastPayday = nextPayday;
    employees[msg.sender].paymentAddr.transfer(employee.salary);
}
