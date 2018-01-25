var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Test add/remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[0], 2);
    }).then(function(){
      assert.equal(payrollInstance.getEmployeeSalary(accounts[0]), 2, "Error when adding employee")
    })
    .then(function() {
      return payrollInstance.removeEmployee(accounts[0]);
    }).then(function() {
      assert.equal(payrollInstance.getEmployeeSalary(accounts[0]), 0 , "Error when removing employee")
    });
  });

});
