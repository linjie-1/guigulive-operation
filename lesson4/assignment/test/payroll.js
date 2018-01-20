var Payroll = artifacts.require("./Payroll.sol");

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

contract('Payroll', (accounts) => {

  it('Test add and remove employee.', () => {
    return Payroll.deployed().then(instance => {
      PayrollInstance = instance;

      return PayrollInstance.addEmployee(accounts[1], 10, {from: accounts[0]});
    }).then(() => {
      return PayrollInstance.employees(accounts[1], {from: accounts[0]});
    }).then(result => {
      assert.equal(result[0], accounts[1], 'add employee fail.');
    }).then(() => {
      return PayrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(() => {
      return PayrollInstance.employees(accounts[1], {from: accounts[0]});
    }).then(result => {
      assert.equal(result[0], '0x0000000000000000000000000000000000000000', 'remove employee fail.');
    }).catch((error) => {
      console.error(error);
    });
  });

  it("Test get paid", () => {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addFund({from: accounts[0], value: web3.toWei('10', 'ether')});
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(() => {
      return PayrollInstance.employees(accounts[1], {from: accounts[0]});
    }).then(result => {
      assert.equal(result[0], accounts[1], 'add employee fail.');
    }).then(async () => {
      await sleep(10000);
      return PayrollInstance.getPaid({from: accounts[1]});
    }).then(() => {
      return PayrollInstance.employees(accounts[1], {from: accounts[0]});
    }).then(result => {
      assert.equal(web3.fromWei(result[1], 'ether'), '1', 'get paid fail.');
    }).catch((error) => {
      console.error(error);
    });
  });

});
