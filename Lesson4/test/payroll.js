const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  let payroll;
  const creator = accounts[0];
  const employeeOneId = accounts[1];
  const employeeTwoId = accounts[2];
  const salary = 1;
  const invalidSalary = -1;

  beforeEach(async function() {
    payroll = await Payroll.new({from: creator});
  });

  it("addEmployee() test owner add new employee with valid salary succeed",
    async function() {

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

  it("addEmployee() test owner add new employee with invalid salary fail",
    async function() {

    await checkEmployeeNotExist(employeeOneId);
    let result = await payroll.addEmployee(
      employeeOneId,
      invalidSalary,
      {from: creator},
    );
    checkTransactionFail(result);
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

  it("removeEmployee() test owner remove existing employee with enough balance succeed",
    async function() {

    let newEmployeeId = web3.personal.newAccount();

    await payroll.addEmployee(newEmployeeId, salary, {from: creator});
    await checkEmployeeExist(newEmployeeId);
    let totalSalary = await genTotalSalary();

    let addFundResult = await payroll.addFund({value: web3.toWei(salary * 2, "ether")});
    checkTransactionSucceed(addFundResult);
    let hasEnoughFund = await payroll.hasEnoughFund.call();
    assert.equal(hasEnoughFund, true, "should have enough fund");

    let employeeOldBalance = getAddressBalance(newEmployeeId);
    let contractOldBalance = getAddressBalance(payroll.address);

    await genWaitForPayDuration(1);

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
    let employeeNewBalance = getAddressBalance(newEmployeeId);
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
    let contractNewBalance = getAddressBalance(payroll.address);
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

  it("removeEmployee() test owner remove existing employee without enough balance fail",
    async function() {

    let newEmployeeId = web3.personal.newAccount();

    await payroll.addEmployee(newEmployeeId, salary, {from: creator});
    await checkEmployeeExist(newEmployeeId);

    let hasEnoughFund = await payroll.hasEnoughFund.call();
    assert.equal(hasEnoughFund, false, "should not have enough fund");

    await genWaitForPayDuration(1);

    let result = await payroll.removeEmployee(newEmployeeId, {from: creator});
    checkTransactionFail(result);
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

  it("getPaid() test employee exist and pay eligible with enough balance succeed",
    async function() {

    await payroll.addEmployee(employeeTwoId, salary, {from: creator});
    await checkEmployeeExist(employeeTwoId);

    await genWaitForPayDuration(1);

    let addFundResult = await payroll.addFund({value: web3.toWei(salary * 2, "ether")});
    checkTransactionSucceed(addFundResult);
    let hasEnoughFund = await payroll.hasEnoughFund.call();
    assert.equal(hasEnoughFund, true, "should have enough fund");

    let employeeOldBalance = getAddressBalance(employeeTwoId);
    let contractOldBalance = getAddressBalance(payroll.address);

    let result = await payroll.getPaid({from: employeeTwoId});
    checkTransactionSucceed(result);

    // verify employee balance
    let employeeNewBalance = getAddressBalance(employeeTwoId);
    assert.isAbove(employeeNewBalance, employeeOldBalance, "Should get paid");

    // verify contract balance
    let contractNewBalance = getAddressBalance(payroll.address);
    assert.isBelow(
      contractNewBalance,
      contractOldBalance,
      "Contract balance should have decreased",
    );
  });

  it("getPaid() test employee not exist fail", async function() {
    await checkEmployeeNotExist(employeeOneId);
    let result = await payroll.getPaid({from: employeeOneId});
    checkTransactionFail(result);
  });

  it("getPaid() test employee exist but too early fail", async function() {
    await payroll.addEmployee(employeeOneId, salary, {from: creator});
    await checkEmployeeExist(employeeOneId);
    let result = await payroll.getPaid({from: employeeOneId});
    checkTransactionFail(result);
  });

  it("getPaid() test employee exist and pay eligible w/o enough balance fail",
    async function() {

    await payroll.addEmployee(employeeOneId, salary, {from: creator});
    await checkEmployeeExist(employeeOneId);

    await genWaitForPayDuration(1);

    let hasEnoughFund = await payroll.hasEnoughFund.call();
    assert.equal(hasEnoughFund, false, "should not have enough fund");

    let result = await payroll.getPaid({from: employeeOneId});
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

  function getAddressBalance(address) {
    return parseFloat(
      web3.fromWei(web3.eth.getBalance(address), 'ether'),
      10,
    );
  }

  // wait for numberOfDuration of duration plus 1 second
  async function genWaitForPayDuration(numberOfDuration) {
    // after one pay duration
    let payDuration = await payroll.payDuration.call();
    let timeToIncrease = payDuration.toNumber() * numberOfDuration + 1;
    web3.currentProvider.sendAsync({
      jsonrpc: '2.0',
      method: 'evm_increaseTime',
      params: [timeToIncrease], // amount of time to increase in seconds
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
  }

});
