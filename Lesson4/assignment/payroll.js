var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("add employee ", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[1], 20, {from: accounts[0]});
    }).then(function() {
      return payrollInstance.isEmployeeExist.call(accounts[1]);
    }).then(function(v) {
      assert.equal(v, true, "the second employee should be exist");
    });
  });

  it("remove employee ", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {
      return payrollInstance.isEmployeeExist.call(accounts[1]);
    }).then(function(v) {
      assert.equal(v, false, "the second employee should not be exist");
    });
  });

});

//code is copid from No.20 shenlongbin
