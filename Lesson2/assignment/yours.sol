/*作业请提交在这个目录下*/
作业一：智能合约代码
pragma solidity ^0.4.14;
//函数的要求为。添加修改删除的人，只能是创建者也就是管理员。其余人等只能才做getPaid给自己法工资。
//大家的薪水支付周期都是一样的,但是薪水肯定是不一样的
contract Payroll {
  struct Employee {
    address id;
    uint salary;
    uint lastPayday;
  }
  uint totalSalary;
  uint constant payDuration = 10 seconds;
  address owner;
  Employee[] employees;

  function Payroll(){
    owner = msg.sender;
  }

  function addFund() payable returns (uint){
    return this.balance / 1 ether;
  }

  //付清这个客户的所有的钱
  function _partialPaid(Employee employee) private{
    //为什么不能将payduration与前面的一起括起来呢
    uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    employee.id.transfer(payment);
  }

  function _findEmployee(address employeeId) private returns (Employee,uint) {
    //在这个函数里，如果遍历完之后均没有满足条件的情况，函数会默认返回一个空的Employee？
    for (uint i = 0;i < employees.length;i++){
      if (employees[i].id == employeeId) {
        return  (employees[i], i);
      }
    }
  }

  function addemployee(address employeeId,uint salary){
    //每一次执行之前都要检查一下这个函数的调用方是否是合约的创建方
    require(msg.sender == owner);
    //用var形式可以获取多个返回值的情况
    var(employee , index) = _findEmployee(employeeId);
    assert(employee.id == 0x0);
    //防止出现重复添加，以addressid作为主键进行判断
    /* for (uint i = 0;i < employees.length;i++){
      if(employees[i].id == employeeId){
        revert();
      }
    } */
    //如果没有重复元素的话，在数组中插入一条元素
    employees.push(Employee(employeeId, salary * 1 ether, now));
    totalSalary += salary * 1 ether;
  }

  function removeEmployee(address employeeId){
    require(msg.sender == owner);
    var(employee , index) = _findEmployee(employeeId);
    assert(employee.id == employeeId);
    totalSalary -= employee.salary;
    //在把这个employee去除出公司之前，要把salary结清
    _partialPaid(employee);
    delete employees[index];
    //将最后一个元素填充至消除的元素位置，length-1。不采用往前移的方式
    employees[index] = employees[employees.length -1];
    employees.length -= 1;
  }

  function updateEmployee(address employeeId,uint salary){
    require(msg.sender == owner);
    var(employee,index) = _findEmployee(employeeId);
    assert(employee.id == employeeId);
    _partialPaid(employee);
    totalSalary -= (employees[index].salary - salary * 1 ether);
    employees[index].salary = salary * 1 ether;
    //每次更新溪水都要
    employees[index].lastPayday = now;
  }

  function calculateRunway() returns (uint) {
    return this.balance / totalSalary;
  }

  function hasEnoughFund() returns (bool){
    return calculateRunway() > 0;
  }

  function getPaid(){
    //只能由合约调用人给自己发工资，其他人不可代劳。如果这个人不在职员清单里。则revert出去；
    var (employee,index) = _findEmployee(msg.sender);
    //断言目前调用合约的人是公司职员
    assert(employee.id != 0x0);
    uint nextPayday = employee.lastPayday + payDuration;
    //确保下一次支付日期是小于今天的，也就是说可以支付
    assert(nextPayday < now);
    employees[index].lastPayday = nextPayday;
    employee.id.transfer(employee.salary);
  }
}

作业二：gas变化的记录

调用calculateRunway时的gas消耗
22988 gas
23769 gas
24550 gas
25331 gas
26112 gas
26893 gas
27674 gas
28455 gas
29236 gas
30017 gas

gas增长原因：随着employees数组的增长，循环体调用次数增加，导致gas增长

作业三：calculateRunway优化

优化思路：每次调用都需要全量循环employees数组，造成gas浪费，故将totalsalary声明为全局变量，
         在每一次会对totalsalary造成变化的地方进行更新。
优化后的gas消耗：每一次calculateRunway优化调用都会消耗 22146 gas


pragma solidity ^0.4.14;
//函数的要求为。添加修改删除的人，只能是创建者也就是管理员。其余人等只能才做getPaid给自己法工资。
//大家的薪水支付周期都是一样的,但是薪水肯定是不一样的
contract Payroll {
  struct Employee {
    address id;
    uint salary;
    uint lastPayday;
  }
  uint totalSalary;
  uint constant payDuration = 10 seconds;
  address owner;
  Employee[] employees;

  function Payroll(){
    owner = msg.sender;
  }

  function addFund() payable returns (uint){
    return this.balance / 1 ether;
  }

  //付清这个客户的所有的钱
  function _partialPaid(Employee employee) private{
    //为什么不能将payduration与前面的一起括起来呢
    uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
    employee.id.transfer(payment);
  }

  function _findEmployee(address employeeId) private returns (Employee,uint) {
    //在这个函数里，如果遍历完之后均没有满足条件的情况，函数会默认返回一个空的Employee？
    for (uint i = 0;i < employees.length;i++){
      if (employees[i].id == employeeId) {
        return  (employees[i], i);
      }
    }
  }

  function addemployee(address employeeId,uint salary){
    //每一次执行之前都要检查一下这个函数的调用方是否是合约的创建方
    require(msg.sender == owner);
    //用var形式可以获取多个返回值的情况
    var(employee , index) = _findEmployee(employeeId);
    assert(employee.id == 0x0);
    //防止出现重复添加，以addressid作为主键进行判断
    //如果没有重复元素的话，在数组中插入一条元素
    employees.push(Employee(employeeId, salary * 1 ether, now));
    totalSalary += salary * 1 ether;
  }

  function removeEmployee(address employeeId){
    require(msg.sender == owner);
    var(employee , index) = _findEmployee(employeeId);
    assert(employee.id == employeeId);
    totalSalary -= employee.salary;
    //在把这个employee去除出公司之前，要把salary结清
    _partialPaid(employee);
    delete employees[index];
    //将最后一个元素填充至消除的元素位置，length-1。不采用往前移的方式
    employees[index] = employees[employees.length -1];
    employees.length -= 1;
  }

  function updateEmployee(address employeeId,uint salary){
    require(msg.sender == owner);
    var(employee,index) = _findEmployee(employeeId);
    assert(employee.id == employeeId);
    _partialPaid(employee);
    totalSalary -= (employees[index].salary - salary * 1 ether);
    employees[index].salary = salary * 1 ether;
    //每次更新溪水都要
    employees[index].lastPayday = now;
  }

  function calculateRunway() returns (uint) {
    return this.balance / totalSalary;
  }

  function hasEnoughFund() returns (bool){
    return calculateRunway() > 0;
  }

  function getPaid(){
    //只能由合约调用人给自己发工资，其他人不可代劳。如果这个人不在职员清单里。则revert出去；
    var (employee,index) = _findEmployee(msg.sender);
    //断言目前调用合约的人是公司职员
    assert(employee.id != 0x0);
    uint nextPayday = employee.lastPayday + payDuration;
    //确保下一次支付日期是小于今天的，也就是说可以支付
    assert(nextPayday < now);
    employees[index].lastPayday = nextPayday;
    employee.id.transfer(employee.salary);
  }
}
