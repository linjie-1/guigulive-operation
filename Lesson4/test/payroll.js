const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  let payroll;
  const creator = accounts[0];
  const employeeId = accounts[1];
  const salary = 5;

  beforeEach(async function() {
    payroll = await Payroll.new({from: creator});
  });

  it("addEmployee() success", async function() {
    // check employeeId has not been added yet
    let employeeData = await payroll.employees(employeeId);
    assert.equal(0x0, employeeData[0], "Employee should not be added yet");

    // test non-owner of the contract cannot add employee
    let result = await payroll.addEmployee(
      employeeId,
      salary,
      {from: employeeId},
    );
    assert.equal(0x00, result.receipt.status, "Add employee should fail");
    employeeData = await payroll.employees(employeeId);
    assert.equal(
      0x0,
      employeeData[0],
      "The employee should not be added by non-owner",
    );

    // test contract owner can add employee
    result = await payroll.addEmployee(employeeId, salary, {from: creator});
    assert.equal(0x01, result.receipt.status, "Add employee should succeed");
    employeeData = await payroll.employees(employeeId);
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
});
