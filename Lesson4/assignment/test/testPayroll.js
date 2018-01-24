var Payroll = artifacts.require("./Payroll");
var sleep = require('sleep-promise');

contract('Payroll', function(accounts) {
  const ownerAddress = accounts[0];
  const employeeAddr = accounts[1];
  const employeeAddr2 = accounts[2];
  let nullAddr = 0x0000000000000000000000000000000000000000;
  let salary = 33;
  let oldTotalSalary = 0;
  var payroll;


  it("add employee not by owner", () => Payroll.deployed()
  .then((instance) => {
    payroll = instance;
    return payroll.addEmployee(employeeAddr, 1, { from: employeeAddr2 });
  }).catch(err => {
    assert(err.message.indexOf("VM Exception while processing transaction: revert") > -1, "not owner assertion");
  }));


  it("add employee for non existed employee by owner", () => Payroll.deployed()
  .then(payroll.totalSalary.call)
  .then(totalSalary => {
    oldTotalSalary = parseInt(totalSalary);
    return payroll.employees.call(employeeAddr);
  }).then(employee => {
    assert.equal(employee[0], nullAddr, "Make sure no such employee before adding");
    payroll.addEmployee(employeeAddr, salary);
    return payroll.employees.call(employeeAddr);
  }).then(employee => {
    console.log('employee', employee);
    assert(employee[0] != nullAddr, "The employee should be added!");
    assert.equal(parseInt(employee[1]), salary, "The employee should have setted salary");
    return payroll.totalSalary.call();
  }).then(totalSalary => {
    assert.equal(oldTotalSalary + salary, parseInt(totalSalary), "totalSalary should been added up");
  }));

  it("add employee for existed employee by owner", () => Payroll.deployed().then((instance) => {
    payroll = instance;
    return instance.totalSalary.call();
  }).then(totalSalary => {
    oldTotalSalary = parseInt(totalSalary);
    return payroll.employees.call(employeeAddr);
  }).then(employee => {
    assert(employee[0] != nullAddr, "Make sure the employee exists before adding");
    return payroll.addEmployee.call(employeeAddr, salary);
  }).catch(err => {
    assert(err.message.indexOf("VM Exception while processing transaction: invalid opcode") > -1, "employee exists assertion");
  }));

  it("remove an employee not by owner", () => Payroll.deployed()
  .then(() => {
    return payroll.removeEmployee(employeeAddr, { from: employeeAddr2 });
  }).catch(err => {
    assert(err.message.indexOf("VM Exception while processing transaction: revert") > -1, "not owner assertion");
  }));

  it("remove a non existed employee by owner", () => Payroll.deployed()
  .then(() => payroll.employeeExists.call(employeeAddr2)
  .then((hasEmployee) => {
    assert.equal(hasEmployee, false, employeeAddr2, "not in employees"); 
    return payroll.removeEmployee(employeeAddr2);
  }))
  .catch(err => {
    assert(err.message.indexOf("VM Exception while processing transaction: invalid opcode") > -1, "employee exists assertion");
  }));


  var lastPayDay;
  it("remove an existed employee after 4 seconds without enough money by owner", () => Payroll.deployed()
  .then(payroll.getBalance.call)
  .then((balance)=>{
    assert.equal(parseInt(balance), 0, "no money in balance");
  })
  .then(payroll.getNow.call)
  .then(payrollNow => console.log("payrollNow", parseInt(payrollNow)))
  .then(() => payroll.employees.call(employeeAddr))
  .then((employee) => {
    assert(employee[0] != nullAddr, "The employee should exist!");
    lastPayDay = parseInt(employee[2]);
    web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [5], id: 0});
    web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
  })
  .then(() => {
    return payroll.removeEmployee.call(employeeAddr);
  })
  .catch(err => {
    assert(err.message.indexOf("VM Exception while processing transaction: invalid opcode") > -1, "employee exists assertion");
  }));

  var initMoney = 10000000000000000;
  var paidDay;
  var payDuration;
  it("remove an existed employee after 4 seconds with enough money by owner", () => Payroll.deployed()
  .then(payroll.getBalance.call)
  .then((balance)=>{
    assert.equal(parseInt(balance), 0, "no money in balance");
  })
  .then(() => {
    return payroll.addFund({value: initMoney});
  })
  .then(payroll.getPayDuration)
  .then(payDuration1 => {
    payDuration = payDuration1;
  })
  .then(payroll.getBalance.call)
  .then((balance)=>{
    assert.equal(parseInt(balance), initMoney, initMoney, " wei in balance");
  }).then(payroll.getNow.call)
  .then(payrollNow => console.log("payrollNow", parseInt(payrollNow)))
  .then(() => payroll.employees.call(employeeAddr))
  .then((employee) => {
    assert(employee[0] != nullAddr, "The employee should exist!");
    lastPayDay = parseInt(employee[2]);
    web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [5], id: 0});
    web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
    return payroll.totalSalary.call();
  }).then(totalSalary => {
    oldTotalSalary = parseInt(totalSalary);
    return payroll.removeEmployee.call(employeeAddr);
  })
  .then(() => payroll.getNow.call())
  .then(now => {paidDay = now})
  .then(() => payroll.employees.call(employeeAddr))
  .then((employee) => {
    assert(employee[0] == nullAddr, "The employee should be removed!");
    return payroll.totalSalary.call();
  }).then((totalSalary) => {
    assert.equal(oldTotalSalary - salary, parseInt(totalSalary), "totalSalary should go down");
    return payroll.getBalance.call();
  }).then((balance) => {
    assert.equal(initMoney - balance, salary * (paidDay - lastPayDay) / payDuration, "balance should go down");    
  }));
});
