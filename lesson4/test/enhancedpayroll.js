var EnhancedPayroll = artifacts.require("./EnhancedPayroll.sol");

contract('EnhancedPayroll', function(accounts) {
  it("should add an employee correctly", function() {
    return EnhancedPayroll.deployed().then(function(instance) {
      return instance.addEmployee(accounts[1], 2);
    }).then(function(instance) {
      assert.equal(instance.employees[accounts[1]].salaryInMonth, 2, "The employee's salary should be 2 ether");
    });
  });
  it("should remove an employee correctly", function() {
    return EnhancedPayroll.deployed().then(function(instance) {
      return instance.removeEmployee(accounts[1]);
    }).then(function(instance) {
      assert.equal(instance.employees[accounts[1]].id, "0x0", "The employee's should have been removed!");
    });
  });
});
