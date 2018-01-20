var Payroll = artifacts.require("./Payroll.sol");
contract('Payroll', function(accounts) {

    it("remove employee should be alright", function() {
      return Payroll.deployed().then(function(instance) {
        var id = 0x3ab555423b7f1471f31692a1c1dea4bb7eee961c;
        payroll = instance;
        payroll.addEmployee(id,11);
        payroll.removeEmployee(id);
      }).then(function() {
        return payroll.getEmployeeId.call(0x3ab555423b7f1471f31692a1c1dea4bb7eee961c);
      }).then(function(addId) {
        console.log(addId);
        assert.equal(addId, 0x0, "remove employee wrong");
      });
    });
  
  });