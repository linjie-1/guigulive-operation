var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

//TEST addEmployee()

  it("...should not add employee, if not owner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1,{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "shall not add");
    });
  });

  it("...should add new employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).then(function() {
      return PayrollInstance.employees(accounts[1]);
    }).then(function(returnData) {
      assert.equal(returnData[0], accounts[1], "The new employee added");
    });
  });


  it("...should not add employee, if already exist", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "The employee already exist");
    });
  });


  //TEST removeEmployee()

  it("...should not remove employee, if not owner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[1],{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "shall not remove");
    });
  });


  it("...should remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
      return PayrollInstance.employees(accounts[1]);
    }).then(function(returnData) {
      assert.equal(returnData[0], '0x0000000000000000000000000000000000000000', "Employee removed");
    });
  });

  it("...error if employee not exist", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[1]);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "can't remove again");
    });
  });


});
