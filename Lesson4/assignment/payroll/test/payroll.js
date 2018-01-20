var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("add employee should be alright", function() {
    return Payroll.deployed().then(function(instance) {
      var id = 0x3ab555423b7f1471f31692a1c1dea4bb7eee961c;
      payroll = instance;
      payroll.addEmployee(id,11);
    }).then(function() {
      return payroll.getEmployeeId.call(0x3ab555423b7f1471f31692a1c1dea4bb7eee961c);
    }).then(function(addId) {
      console.log(addId);
      assert.equal(addId, 0x3ab555423b7f1471f31692a1c1dea4bb7eee961c, "add employee wrong");
    });
  });

});



