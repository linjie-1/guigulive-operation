var Payroll = artifacts.require("./Payroll.sol");

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

contract('Payroll', (accounts) => {

  before('setup', () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
    });
  });

  describe('Test Fund', () => {

    it('add fund', () => {
      return Promise.resolve().then(() => {
        return PayrollInstance.addFund({ from: accounts[0], value: web3.toWei('10', 'ether') });
      }).then(result => {
        assert.equal(web3.fromWei(web3.eth.getBalance(PayrollInstance.address), 'ether'), '10', 'add employee fail.');
      }).catch((error) => {
        console.error(error);
      });
    });

  });

  describe('Test Employee', () => {

    it('add employee', () => {
      return Promise.resolve().then(() => {
        return PayrollInstance.addEmployee(accounts[1], 1, { from: accounts[0] });
      }).then(() => {
        return PayrollInstance.employees(accounts[1], { from: accounts[0] });
      }).then(result => {
        assert.equal(result[0], accounts[1], 'add employee fail.');
      }).catch((error) => {
        console.error(error);
      });
    });

    it('add employee only owner', () => {
      return Promise.resolve().then(() => {
        return PayrollInstance.addEmployee(accounts[2], 1, { from: accounts[2] });
      }).then(() => {
        return PayrollInstance.employees(accounts[2], { from: accounts[0] });
      }).then(result => {
        assert.equal(result[0], '0x0000000000000000000000000000000000000000', 'add employee only owner fail.');
      }).catch((error) => {
        console.error(error);
      });
    });

    it("get paid", () => {
      return sleep(10000).then(() => {
        return PayrollInstance.getPaid({ from: accounts[1] });
      }).then(() => {
        return PayrollInstance.employees(accounts[1], { from: accounts[0] });
      }).then(result => {
        assert.equal(web3.fromWei(result[1], 'ether'), '1', 'get paid fail.');
      }).catch((error) => {
        console.error(error);
      });
    });

    it('remove employee', function () {
      return Promise.resolve().then(() => {
        return PayrollInstance.employees(accounts[1], { from: accounts[0] });
      }).then(result => {
        assert.equal(result[0], accounts[1], 'remove employee not exist.');
      }).then(() => {
        return PayrollInstance.removeEmployee(accounts[1], { from: accounts[0] });
      }).then(() => {
        return PayrollInstance.employees(accounts[1], { from: accounts[0] });
      }).then(result => {
        assert.equal(result[0], '0x0000000000000000000000000000000000000000', 'remove employee fail.');
        assert.equal(result[1], '0', 'remove employee fail.');
        assert.equal(result[2], '0', 'remove employee fail.');
      }).catch((error) => {
        console.error(error);
      });
    });

  });

});


var Ownable = artifacts.require("./Ownable.sol");

contract('Ownable', (accounts) => {

  before('setup', () => {
    return Ownable.deployed().then((instance) => {
        OwnableInstance = instance;
        console.log(OwnableInstance);
    });
  });

});