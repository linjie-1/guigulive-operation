const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  let payroll;
  const creator = accounts[0];
  const employeeId = accounts[1];
  const salary = 5;

  beforeEach(async function() {
    payroll = await Payroll.new({from: creator});
  });

  it("addEmployee() test owner adding new employee succeed", async function() {
    await checkEmployeeNotExist(employeeId);
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
  });

  it("addEmployee() test owner adding existing employee fail",
    async function() {

    await payroll.addEmployee(employeeId, salary, {from: creator});
    await checkEmployeeExist(employeeId);
    let result = await payroll.addEmployee(employeeId, salary, {from: creator});
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner adding new employee fail", async function() {
    await checkEmployeeNotExist(employeeId);
    let result = await payroll.addEmployee(
      employeeId,
      salary,
      {from: employeeId},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner adding existing employee fail",
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

});
