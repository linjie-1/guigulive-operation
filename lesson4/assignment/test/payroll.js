var Payroll = artifacts.require("./Payroll.sol");

// TODO: replace expectRevert with zeppelin's assertRevert helper
var expectRevert = async promise => {
  try {
    await promise;
    assert.fail('Expected revert not received');
  } catch (error) {
    const revertFound = error.message.search('revert') >= 0;
    assert(revertFound, `Expected "revert", got ${error} instead`);
  }
};

// TODO: replace expectRevert with zeppelin's increaseTime helper
var increaseTime = (duration) => {
  const id = Date.now();

  return new Promise((resolve, reject) => {
    web3.currentProvider.sendAsync({
      jsonrpc: '2.0',
      method: 'evm_increaseTime',
      params: [duration],
      id: id,
    }, err1 => {
      if (err1) return reject(err1);
      web3.currentProvider.sendAsync({
        jsonrpc: '2.0',
        method: 'evm_mine',
        id: id + 1,
      }, (err2, res) => {
        return err2 ? reject(err2) : resolve(res);
      });
    });
  });
};

contract('Payroll.addEmployee', async function(accounts) {
  let payrollInstance = await Payroll.deployed();

  it("Should succeed if adding inexistent employee.", async function() {
    let fakeAddress = '0x24f176f477939330307f4e7adcdff051dd0f6658';
    let storedData = await payrollInstance.employees.call(fakeAddress);
    assert.isUndefined(storedData.addr, "The fake address should not exist before adding it.");
    await payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[0]});
    storedData = await payrollInstance.employees.call(fakeAddress);
    assert.equal(storedData[0], fakeAddress, "The fake address should exist.");
  });

  it("Should fail if adding existing employee.", async function() {
    let fakeAddress = '0x5e25401aef6d2784c2f35e0d2da61cd775c5792e';
    await payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[0]});
    let storedData = await payrollInstance.employees.call(fakeAddress);
    assert.equal(storedData[0], fakeAddress, "The fake address should exist.");

    await expectRevert(payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[0]}));
  });

  it("Should fail if msg.sender is not owner", async function() {
    let fakeAddress = '0x43c46c64fbc6086367d0f7ae9158f2dac98dd209';
    await expectRevert(payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[1]}));
  });

  it("Should fail if addr is 0x0", async function() {
    let fakeAddress = '0x0';
    await expectRevert(payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[0]}));
  });
});

contract('Payroll.removeEmployee', async function(accounts) {
  let payrollInstance = await Payroll.deployed();

  it("Should succeed if removing existing employee.", async function() {
    let fakeAddress = '0xa4fd4d9df2e0be4812854efa494980fff669668b';
    await payrollInstance.addEmployee(fakeAddress, 1, {from: accounts[0]});
    let storedData = await payrollInstance.employees.call(fakeAddress);
    assert.equal(storedData[0], fakeAddress, "The fake address should exist.");

    await payrollInstance.removeEmployee(fakeAddress, {from: accounts[0]});
    storedData = await payrollInstance.employees.call(fakeAddress);
    assert.equal(storedData[0].valueOf(), 0x0, "The fake address should not exist.");
  });

  it("Should fail if removing inexistent employee.", async function() {
    let fakeAddress = '0x218ea5c1c140297dd7194f9a5cf1b4bbde00bb1e';
    await expectRevert(payrollInstance.removeEmployee(fakeAddress, {from: accounts[0]}));
  });

  it("Should fail if msg.sender is not owner", async function() {
    let fakeAddress = '0xdd12f8c4e5f62fa68ef27035cc6f2393f3b57628';
    await expectRevert(payrollInstance.removeEmployee(fakeAddress, {from: accounts[1]}));
  });
});

contract('Payroll.getPaid', async function(accounts) {
  let payrollInstance = await Payroll.deployed();

  it("Should succeed if employee exists and works longer than Payroll.PAY_DURATION.", async function() {
    let employeeAddress = accounts[1];
    await payrollInstance.addEmployee(employeeAddress, 1, {from: accounts[0]});
    await payrollInstance.addFund({from: employeeAddress, value: web3.toWei(1, "ether")});
    let storedData = await payrollInstance.employees.call(employeeAddress);
    assert.equal(storedData[0], employeeAddress, "The employee address should exist.");
    let originalBalance = web3.eth.getBalance(employeeAddress);

    let pay_duration = await payrollInstance.PAY_DURATION.call();

    await increaseTime(pay_duration); // seconds

    let transactionResult = await payrollInstance.getPaid({from: employeeAddress, gasPrice: 0});
    let newBalance = web3.eth.getBalance(employeeAddress);
    let gas = transactionResult.receipt.gasUsed * web3.eth.gasPrice;
    let expectedBalance = originalBalance.toNumber() + parseInt(web3.toWei(1, "ether"));
    assert.equal(newBalance.toNumber(), expectedBalance, "Should be paid 1 ether");
  });

  it("Should fail if working time is shorter than Payroll.PAY_DURATION.", async function() {
    let employeeAddress = accounts[2];
    await payrollInstance.addEmployee(employeeAddress, 1, {from: accounts[0]});
    let storedData = await payrollInstance.employees.call(employeeAddress);
    assert.equal(storedData[0], employeeAddress, "The employee address should exist.");

    await expectRevert(payrollInstance.getPaid({from: employeeAddress}));
  });

  it("Should fail if employee doesn't exist.", async function() {
    let employeeAddress = accounts[3];
    await expectRevert(payrollInstance.getPaid({from: employeeAddress}));
  });
});
