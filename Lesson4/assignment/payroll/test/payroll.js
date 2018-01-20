var Payroll = artifacts.require('./Payroll.sol');

contract('Payroll', accounts => {
  it('should add and remove employee successfully', () => {
    let payroll;
    Payroll.deployed()
      .then(instance => {
        payroll = instance;
        return payroll.addEmployee(accounts[1], 1);
      })
      .then(() => payroll.hasEmployee.call(accounts[1]))
      .then(hasEmployee => {
        assert.isTrue(hasEmployee);
        return payroll.changePaymentAddress(accounts[1]);
      })
      .then(() => payroll.hasEmployee.call(accounts[1]))
      .then(hasEmployee => assert.isNotTrue(hasEmployee));
  });

  it('should fail adding same employee', () => {
    let payroll;
    Payroll.deployed()
      .then(instance => {
        payroll = instance;
        return payroll.addEmployee(accounts[1], 1);
      })
      .then(() => payroll.addEmployee(accounts[1], 1))
      .catch(error =>
        assert(
          error.toString().includes('invalid opcode'),
          'employee alread added'
        )
      );
  });

  it('should add 50 ether', () => {
    let payroll;
    Payroll.deployed()
      .then(instance => {
        payroll = instance;
        return payroll.addFund({ value: web3.toWei('50', 'ether') });
      })
      .then(balance => {
        assert(
          web3.eth.getBalance(payroll.address).toNumber() ==
            web3.toWei('50', 'ether')
        );
      });
  });

  it('should get paid successfully', () => {
    let payroll;
    let balanceBefore = web3.eth.getBalance(accounts[2]).toNumber();
    Payroll.deployed()
      .then(instance => {
        payroll = instance;
        return payroll.addEmployee(accounts[2], 1);
      })
      .then(() => {
        return new Promise(resolve =>
          setTimeout(() => {
            resolve();
          }, 11000)
        );
      })
      .then(() => payroll.getPaid({ from: accounts[2] }))
      .then(() => {
        assert(
          web3.eth.getBalance(accounts[2]).toNumber() - balanceBefore ==
            web3.toWei('1', 'ether')
        );
      });
  });

  it('should fail get paid', () => {
    let payroll;
    Payroll.deployed()
      .then(instance => {
        payroll = instance;
        return payroll.addEmployee(accounts[2], 1);
      })
      .then(() => {
        return new Promise(resolve =>
          setTimeout(() => {
            resolve();
          }, 3000)
        );
      })
      .then(() => payroll.getPaid({ from: accounts[2] }))
      .catch(error =>
        assert(
          error.toString().includes('invalid opcode'),
          'unable to get paid'
        )
      );
  });
});
