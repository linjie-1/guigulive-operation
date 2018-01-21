const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  let payroll;
  const creator = accounts[0];
  const employeeOneId = accounts[1];
  const salary = 1;
  const invalidSalary = -1;

  beforeEach(async function() {
    payroll = await Payroll.new({from: creator});
  });

  it("addEmployee() test owner add new employee succeed", async function() {
    await checkEmployeeNotExist(employeeOneId);
    let totalSalary = await genTotalSalary();
    assert.equal(totalSalary, 0, "initial totalSalary should be 0");
    let result = await payroll.addEmployee(employeeOneId, salary, {from: creator});
    checkTransactionSucceed(result);
    let employeeData = await payroll.employees(employeeOneId);
    assert.equal(
      employeeOneId,
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
    await payroll.addEmployee(employeeOneId, salary, {from: creator});
    await checkEmployeeExist(employeeOneId);
    let result = await payroll.addEmployee(employeeOneId, salary, {from: creator});
    checkTransactionFail(result);
  });

  it("addEmployee() test owner add 0x0 address fail", async function() {
    let result = await payroll.addEmployee(0x0, salary, {from: creator});
    checkTransactionFail(result);
  });

  it("addEmployee() test owner add existing employee with invalid salary fail",
    async function() {

    let result = await payroll.addEmployee(
      employeeOneId,
      invalidSalary,
      {from: creator},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add new employee fail", async function() {
    await checkEmployeeNotExist(employeeOneId);
    let result = await payroll.addEmployee(
      employeeOneId,
      salary,
      {from: employeeOneId},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add existing employee fail",
    async function() {

    await payroll.addEmployee(employeeOneId, salary, {from: creator});
    await checkEmployeeExist(employeeOneId);
    let result = await payroll.addEmployee(
      employeeOneId,
      salary,
      {from: employeeOneId},
    );
    checkTransactionFail(result);
  });

  it("addEmployee() test non-owner add 0x0 address fail", async function() {
    let result = await payroll.addEmployee(0x0, salary, {from: employeeOneId});
    checkTransactionFail(result);
  });

  it("removeEmployee() test owner remove existing employee succeed",
    async function() {

    let newEmployeeId = web3.personal.newAccount();

    await payroll.addEmployee(newEmployeeId, salary, {from: creator});
    await checkEmployeeExist(newEmployeeId);
    let totalSalary = await genTotalSalary();

    let addFundResult = await payroll.addFund({value: web3.toWei(salary * 2, "ether")});
    checkTransactionSucceed(addFundResult);
    let employeeOldBalance = parseFloat(
      web3.fromWei(web3.eth.getBalance(newEmployeeId), 'ether'),
      10,
    );
    let contractOldBalance = parseFloat(
      web3.fromWei(web3.eth.getBalance(payroll.address), 'ether'),
      10,
    );
    assert.isAbove(
      contractOldBalance,
      salary,
      "contract should have enough balance to pay the employee",
    );

    // after one pay duration
    let payDuration = await payroll.payDuration.call();
    web3.currentProvider.sendAsync({
      jsonrpc: '2.0',
      method: 'evm_increaseTime',
      params: [payDuration.toNumber() + 1], // amount of time to increase in seconds
      id: 0
    }, (err, resp) => {
      if (!err) {
        web3.currentProvider.send({
          jsonrpc: '2.0',
          method: 'evm_mine',
          params: [],
          id: 1
        })
      }
    });

    let result = await payroll.removeEmployee(newEmployeeId, {from: creator});
    checkTransactionSucceed(result);
    await checkEmployeeNotExist(newEmployeeId);
    let updatedTotalSalary = await genTotalSalary();
    assert.equal(
      updatedTotalSalary,
      totalSalary - salary,
      "totalSalary should be decreased",
    );

    // verify employee balance
    let employeeNewBalance = parseFloat(
      web3.fromWei(web3.eth.getBalance(newEmployeeId), 'ether'),
      10,
    );
    assert.isAbove(
      employeeNewBalance - employeeOldBalance,
      salary,
      "Partial paid amount should be a little bit over one full payment cycle salary",
    );
    assert.isBelow(
      employeeNewBalance - employeeOldBalance,
      salary * 2,
      "Partial paid amount should be less than two full payment cycle salary",
    );

    // verify contract balance
    let contractNewBalance = parseFloat(
      web3.fromWei(web3.eth.getBalance(payroll.address), 'ether'),
      10,
    );
    assert.isAbove(
      contractOldBalance - contractNewBalance,
      salary,
      "Paid amount should be a little bit over one full payment cycle salary",
    );
    assert.isBelow(
      contractOldBalance - contractNewBalance,
      salary * 2,
      "Paid amount should be less than two full payment cycle salary",
    );
  });

  it("removeEmployee() test owner remove non-existing employee fail",
    async function() {

    await checkEmployeeNotExist(employeeOneId);
    let result = await payroll.removeEmployee(employeeOneId, {from: creator});
    checkTransactionFail(result);
  });

  it("removeEmployee() test non-owner remove existing employee fail",
    async function() {

    await payroll.addEmployee(employeeOneId, salary, {from: creator});
    await checkEmployeeExist(employeeOneId);
    let result = await payroll.removeEmployee(employeeOneId, {from: employeeOneId});
    checkTransactionFail(result);
  });

  it("removeEmployee() test non-owner remove non-existing employee fail",
    async function() {

    await checkEmployeeNotExist(employeeOneId);
    let result = await payroll.removeEmployee(employeeOneId, {from: employeeOneId});
    checkTransactionFail(result);
  });

  async function checkEmployeeNotExist(employeeOneId) {
    let employeeData = await payroll.employees(employeeOneId);
    assert.equal(0x0, employeeData[0], "Employee should not exist");
  }

  async function checkEmployeeExist(employeeOneId) {
    let employeeData = await payroll.employees(employeeOneId);
    assert.equal(
      employeeOneId,
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
