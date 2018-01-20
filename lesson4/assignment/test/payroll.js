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
