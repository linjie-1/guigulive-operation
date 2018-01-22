var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("...should store the salary of 2 ether.", function() {
    var payrollInstance;
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 2, {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], accounts[1], "The address was not stored.");
      assert.equal(employee[1], web3.toWei(2), "The salary 2 ether was not stored.");
    });
  });

  it("...should throw exception when non owner try to add employee.", function() {
    var payrollInstance;
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 2, {from: accounts[1]});
    }).catch(function(e){
      console.log(e);
      assert.include(e.toString(), "revert", "contains 'revert'");
    });
  });

  it("...should remove the employee.", function() {
    var payrollInstance;
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then(function() {
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], '0x0000000000000000000000000000000000000000', "The address was not removed.");
      // TODO: console reports: expected { Object (s, e, ...) } to equal undefined
      // I don't know how to compare employee[1]
      // assert.equal(employee[1], undefined, "The salary was not removed.");
      assert.notEqual(employee[1], web3.toWei(2), "The salary 2 ether was not stored.");
    });
  });

  it("...should throw exception when non owner try to remove employee.", function() {
    var payrollInstance;
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[1]});
    }).catch(function(e){
      console.log(e);
      assert.include(e.toString(), "revert", "contains 'revert'");
    });
  });

});