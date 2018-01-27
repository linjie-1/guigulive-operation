var EnhancedPayroll = artifacts.require("./EnhancedPayroll.sol");

var addressId = "0x58100fdb2b03966c4c8b000ba88a8f13852aee3d";
var contractInstance;

contract('EnhancedPayroll', function() {
  it("add an employee", function() {
    return EnhancedPayroll.deployed()
    .then(function(instance) {
      contractInstance = instance;
      return contractInstance.addEmployee(addressId, 2);
    }).then(function() {
      return contractInstance.getEmployeeInfo(addressId);
    }).then(function(result) {
      console.log("hello world");
      console.log(result);
      assert(result);
    });
  });
  // it("should remove an employee correctly", function() {
  //   return EnhancedPayroll.deployed().then(function(instance) {
  //     return instance.removeEmployee(accounts[1]);
  //   }).then(function(instance) {
  //     assert.equal(instance.employees[accounts[1]].id, "0x0", "The employee's should have been removed!");
  //   });
  // });
});
