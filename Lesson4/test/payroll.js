var Payroll = artifacts.require("./Payroll.sol");

contract('TestPayroll', function(accounts) {
  var testSalary = 1;
  var testBalance = 50;
  var owner = accounts[0];
  var employee = accounts[1];

  it("It should add employee.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(employee, testSalary, {from: owner});
    }).then(function() {
      return PayrollInstance.employees(employee);
    }).then(function(newEmployee) {
      assert.equal(newEmployee[0], employee, "Employee should exist");
      assert.equal(newEmployee[1].toNumber(), testSalary, "Salary should be 1.");
    });
  });

  it("It should add fund.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addFund.call({value: testBalance,from: owner});
    }).then(function(balance) {
      assert.equal(balance.toNumber(), testBalance, "Balance should be 50.");
    });
  });

  it("It should remove employee.(js)", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      PayrollInstance.removeEmployee(employee, {from: owner});
      return PayrollInstance.employees(employee);
    }).then(function(deleteEmployee) {
      assert.equal(deleteEmployee[0], 0x00, "Employee should not exist");
      assert.equal(deleteEmployee[1], 0, "Salary should be 0.");
    });
  });
});
