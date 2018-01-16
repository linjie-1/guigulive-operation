/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
  uint constant payDuration = 10 seconds;

  uint salary = 1 ether;
  address employee;
  address owner;
  uint lastPayDay = now;

  function Payroll() {
    owner = msg.sender;
  }

  function updateEmployee(address e, uint s) {
    require(msg.sender == owner);

    if (employee != 0x0) {
      uint payment = salary * (now - lastPayDay) / payDuration;
      employee.transfer(payment);
    }

    employee = e;
    salary = s * 1 ether;
    lastPayDay = now;
  }

  function addFund() payable returns (uint) {
    return this.balance;
  }

  function calculateRunway() returns (uint) {
    return this.balance / salary;
  }

  function hasEnoughFund() returns (bool) {
    return calculateRunway() > 0;
  }

  function getPaid() {
    require(msg.sender == employee);
    uint nextPayDay = lastPayDay + payDuration;
    assert(now >= nextPayDay);
    lastPayDay = nextPayDay;
    employee.transfer(salary);
  }

  function updateAddress(address e) {
    updateEmployee(e, salary);
  }

  function updateSalary(uint s) {
    updateEmployee(employee, s);
  }
}
