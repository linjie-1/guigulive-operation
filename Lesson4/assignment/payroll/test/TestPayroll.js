var Payroll = artifacts.require("./Payroll.sol");
var Owner = artifacts.require("./Owner.sol");
var SafeMath = artifacts.require("./SafeMath.sol");

contract('TestPayroll', function(accounts) {
  // const testEmployeeId = 0x1166fdf965cdd024bf6e7c520dc0f3ff3ec94d19;
  var testSalary = 1;
  var testBalance = 50;
  var owner = accounts[0];

  it("It should add fund.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addFund.call({value: web3.toWei(testBalance, 'ether'),from: owner});
    }).then(function(balance) {
      assert.equal(balance.toNumber(), web3.toWei(testBalance));
    }).catch(function(error){
      console.log(error);
    });
  });

  it("It should add employee.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], testSalary, {from: owner});
    }).then(function() {
      return PayrollInstance.employees(accounts[1]);
    }).then(function(newEmployee) {
      assert.equal(newEmployee[0], accounts[1]);
      assert.equal(newEmployee[1], web3.toWei(testSalary, 'ether'));
    }).catch(function(error) {
      console.log(error)
    });
  });

  it("It should remove employee.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      PayrollInstance.removeEmployee(accounts[1], {from: owner});
      return PayrollInstance.employees(accounts[1]);
    }).then(function(deleteEmployee) {
      assert.equal(deleteEmployee[0], 0x00);
      assert.equal(deleteEmployee[1], 0);
    }).catch(function(error) {
      console.log(error)
    });
  });

  // it("It should get paid.(js)", function() {
  //   return Payroll.deployed().then(function(instance) {
  //     PayrollInstance = instance;
  //     PayrollInstance.addEmployee(accounts[2], testSalary, {from: owner});
  //     initBalance = web3.eth.getBalance(accounts[2]).toNumber();

  //     let waitPaid = new Promise(function(resolve, reject) {
  //       setTimeout(function(PayrollInstance) {
  //         PayrollInstance.addEmployee(accounts[3], testSalary, {from: owner});
  //         resolve(PayrollInstance.employees(accounts[2]));
  //       }, 5000)
  //     });
  //     return waitPaid;
  //   }).then(function(employee) {
  //   }).catch(function(error) {
  //     console.log(error)
  //   });
  // });
});
