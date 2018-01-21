const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  let payroll;
  const creator = accounts[0];
  const employeeId = accounts[1];
  const salary = 5;
  const invalidSalary = -5;

  beforeEach(async function() {
    payroll = await Payroll.new({from: creator});
  });

  it("addEmployee() test owner add new employee succeed", async function() {
    await checkEmployeeNotExist(employeeId);
    let totalSalary = await genTotalSalary();
    assert.equal(totalSalary, 0, "initial totalSalary should be 0");
    let result = await payroll.addEmployee(employeeId, salary, {from: creator});
    checkTransactionSucceed(result);
    let employeeData = await payroll.employees(employeeId);
    assert.equal(
      employeeId,
      employeeData[0],
      "Employee id does not match"
    );
    assert.equal(
      salary,
      parseInt(web3.fromWei(employeeData[1], 'ether'), 10),
      "Employee salary does not match"
    );
    assert.equal(
      web3.eth.getBlock(result.receipt.blockNumber).timestamp,
      parseInt(employeeData[2], 10),
      "LastPayday does not match"
    );
    let updatedTotalSalary = await genTotalSalary();
    assert.equal(
      updatedTotalSalary,
      totalSalary + salary,
      "totalSalary should be increased",
    );
  });

  it("addEmployee() test owner add existing employee fail", async function() {
    await payroll.addEmployee(employeeId, salary, {from: creator});
    await checkEmployeeExist(employeeId);
    let result = await payroll.addEmployee(employeeId, salary, {from: creator});
    checkTransactionFail(result);
  });

  it("addEmployee() test owner add 0x0 address fail", async function() {
    let result = await payroll.addEmployee(0x0, salary, {from: creator});
    checkTransactionFail(result);
  });

  it("addEmployee() test owner add existing employee with invalid salary fail",
    async function() {

    let result = await payroll.addEmployee(
      employeeId,
      invalidSalary,
      {from: creator},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add new employee fail", async function() {
    await checkEmployeeNotExist(employeeId);
    let result = await payroll.addEmployee(
      employeeId,
      salary,
      {from: employeeId},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add existing employee fail",
    async function() {

    await payroll.addEmployee(employeeId, salary, {from: creator});
    await checkEmployeeExist(employeeId);
    let result = await payroll.addEmployee(
      employeeId,
      salary,
      {from: employeeId},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add 0x0 address fail", async function() {
    let result = await payroll.addEmployee(0x0, salary, {from: employeeId});
    checkTransactionFail(result);
  });

  it("removeEmployee() test owner remove existing employee succeed",
    async function() {

    await payroll.addEmployee(employeeId, salary, {from: creator});
    await checkEmployeeExist(employeeId);
    let totalSalary = await genTotalSalary();

    let result = await payroll.removeEmployee(employeeId, {from: creator});
    checkTransactionSucceed(result);
    await checkEmployeeNotExist(employeeId);
    let updatedTotalSalary = await genTotalSalary();
    assert.equal(
      updatedTotalSalary,
      totalSalary - salary,
      "totalSalary should be decreased",
    );
  });

  it("removeEmployee() test owner remove non-existing employee fail",
    async function() {

    await checkEmployeeNotExist(employeeId);
    let result = await payroll.removeEmployee(employeeId, {from: creator});
    checkTransactionFail(result);
  });

  it("removeEmployee() test non-owner remove existing employee fail",
    async function() {

    await payroll.addEmployee(employeeId, salary, {from: creator});
    await checkEmployeeExist(employeeId);
    let result = await payroll.removeEmployee(employeeId, {from: employeeId});
    checkTransactionFail(result);
  });

  it("removeEmployee() test non-owner remove non-existing employee fail",
    async function() {

    await checkEmployeeNotExist(employeeId);
    let result = await payroll.removeEmployee(employeeId, {from: employeeId});
    checkTransactionFail(result);
  });

  async function checkEmployeeNotExist(employeeId) {
    let employeeData = await payroll.employees(employeeId);
    assert.equal(0x0, employeeData[0], "Employee should not exist");
  }

  async function checkEmployeeExist(employeeId) {
    let employeeData = await payroll.employees(employeeId);
    assert.equal(
      employeeId,
      employeeData[0],
      "Employee should exist");
  }

  function checkTransactionFail(result) {
    assert.equal(0x00, result.receipt.status, "Transaction should fail");
  }

  function checkTransactionSucceed(result) {
    assert.equal(0x01, result.receipt.status, "Transaction should succeed");
  }

  async function genTotalSalary() {
    let totalSalary = await payroll.totalSalary.call();
    return parseInt(web3.fromWei(totalSalary, 'ether'), 10);
  }

});
