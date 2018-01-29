var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', async function(accounts) {
  var testId = web3.eth.accounts[2];
  var salary = 1;

  let payroll;

  before(async () => {
    payroll = await Payroll.new({from : accounts[0]});
    const fund = web3.toWei("5", "ether");
    await payroll.addFund({from : accounts[1], value: fund});
    assert.equal(fund, web3.eth.getBalance(payroll.address).toString());
  });

  it("should add employee.", async () => {
    await payroll.addEmployee(testId, salary);
    var employee = await payroll.employees(testId);
    assert.equal(employee[0], testId, "The employee isn't added.");
    assert.equal(employee[1], web3.toWei(salary, "ether").toString(), "Salary isn't correct");
  });

  it("should remove employee.", async () => {
    await payroll.removeEmployee(testId);
    var employee = await payroll.employees(testId);
    assert.equal(employee[0], '0x0000000000000000000000000000000000000000', "The employee isn't removed.");
    assert.equal(employee[1], 0, "Salary isn't correct");
  });

});
