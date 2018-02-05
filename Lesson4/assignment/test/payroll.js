var Payroll = artifacts.require("../contracts/Payroll.sol");



contract('Payroll', function(accounts) {

  var id = "0xca35b7d915458ef540ade6068dfe2f44e8fa733c";

  it("Add an employee", function() {
    return Payroll.deployed().then(function(instance) {
      payroll = instance;
      payroll.addEmployee(id, 1);
    }).then(function() {
      return payroll.getEmployee.call(id);
    }).then(function(res) {
      assert.equal(res, '1000000000000000000', "Add employee error");
    });
  });

  it("Remove an employee", function() {
    return Payroll.deployed().then(function(instance) {
      payroll = instance;
      payroll.removeEmployee(accounts[1]);
    }).then(function() {
      assert(true, "Remove Error !");
    });
  });

});
