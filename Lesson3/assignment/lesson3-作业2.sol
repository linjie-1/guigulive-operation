pragma solidity ^0.4.14;

contract Payroll {
  struct Employee {
    address id;
    uint salary;
    uint lastPayday;
  }
  mapping(address => Employee) employees ;
  uint totalSalary;
  uint constant payDuration = 10 seconds;
  address owner;

  function Payroll(){
    owner = msg.sender;
  }

  modifier onlyOwner{
    require(msg.sender == owner);
    _;
  }

  modifier employeeExist(address employeeId){
    var employee  = employees[employeeId];
    assert(employee.id == employeeId);
    _;
  }

  modifier ownerOrSelf(address employeeId){
    var employee = employees[employeeId];
    require((msg.sender == owner && employee.id == employeeId) || msg.sender == employee.id);
    _;
    }

  function addFund() payable returns (uint){
    return this.balance / 1 ether;
  }
  //在对该employee执行变更之前，将所有历史薪水付给他
  function _partialPaid(Employee employee) private{
    uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    employee.id.transfer(payment);
  }
  //规则，只有合约创建者和该员工才可以修改收钱地址，修改employee.id地址，并且更新mapping.
  //更改收款地址，原有的salary没有做变更，所以未来付款时历史薪水还是可以算出来的，故不需要执行_partialPaid函数来付清历史薪水
  function changePaymentAddress(address employeeSoureceId,address employeeDesId) ownerOrSelf(employeeSoureceId) {
    var employee = employees[employeeSoureceId];
    employee.id =  employeeDesId;
    employees[employeeDesId] = employee;
    delete employees[employeeSoureceId];
  }
  function addemployee(address employeeId,uint salary) onlyOwner{
    var employee  = employees[employeeId];
    assert(employee.id == 0x0);
    employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    totalSalary += salary * 1 ether;
  }

  function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
    var employee = employees[employeeId];
    totalSalary -= employee.salary;
    _partialPaid(employee);
    delete employees[employeeId];
  }

  function updateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId){
    var employee = employees[employeeId];
    _partialPaid(employee);
    totalSalary -= (employees[employeeId].salary - salary * 1 ether);
    employees[employeeId].salary = salary * 1 ether;
    employees[employeeId].lastPayday = now;
  }

  function calculateRunway() returns (uint) {
    return this.balance / totalSalary;
  }

  function hasEnoughFund() returns (bool){
    return calculateRunway() > 0;
  }
  function checkEmployee(address employeeId) returns (uint salary,uint lastPayday){
    var employee = employees[employeeId];
    salary = employee.salary;
    lastPayday = employee.lastPayday;
  }
  function getPaid() {
    var employee = employees[msg.sender];
    assert(employee.id != 0x0);
    uint nextPayday = employee.lastPayday + payDuration;
    assert(nextPayday < now);
    employees[msg.sender].lastPayday = nextPayday;
    employee.id.transfer(employee.salary);
  }
}
