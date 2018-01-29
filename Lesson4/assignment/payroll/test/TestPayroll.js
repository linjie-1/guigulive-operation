var Payroll = artifacts.require("./Payroll.sol");
var Owner = artifacts.require("./Owner.sol");
var SafeMath = artifacts.require("./SafeMath.sol");

contract('TestPayroll', function(accounts) {
  var testSalary = 1;
  var testBalance = 50;
  var owner = accounts[0];

  // test addFund
  it("It should add fund.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addFund.call({value: web3.toWei(testBalance, 'ether'),from: owner});
    }).then(function(balance) {
      assert.equal(balance.toNumber(), web3.toWei(testBalance), 'add fund');
    }).catch(function(error){
      console.log(error);
    });
  });

  // test addEmployee
  it("only owner can add employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], testSalary, {from: accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('revert'), "only owner can add employee");
    });
  });

  it("if exployee already exist, can't add employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], testSalary, {from: owner});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "The employee already exist");
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
      assert.equal(newEmployee[1], web3.toWei(testSalary, 'ether'), "add new employee");
    }).catch(function(error) {
      console.log(error)
    });
  });

  //test removeEmployee
  it("only owner can remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[1], {from: accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('revert'), "only owner can remove employee");
    });
  });

  it("if exployee not exist, can't remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[3], {from: owner});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "The employee not exist");
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
  //         PayrollInstance.getPaid({from: accounts[2]});
  //         resolve(PayrollInstance.employees(accounts[2]));
  //       }, 11000)
  //     });
  //     return waitPaid;
  //     // return waitPaid;
  //     // sleep(10);
  //     //return PayrollInstance.employees(accounts[2]);
  //   }).then(function(employee) {
  //     // assert.(deleteEmployee[0], 0x00);
  //     assert( employee[1] > initBalance)
  //   }).catch(function(error) {
  //     console.log(error)
  //   });
  // });
});
