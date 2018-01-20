var Payroll = artifacts.require("./Payroll.sol");
const ether = 1000000000000000000;

contract('Payroll', function(accounts) {

  it("Employee with wallet: test account[8] and salary: 1 ether should be stored.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(1, accounts[8]);
    }).then(function() {
      return payrollInstance.isEmployeeExist.call(accounts[8]);
    }).then(function(isExist) {
      assert.equal(isExist, true, "The test account[9] with 1 ether salary was not stored.");
    });
  });

  it("Employee with wallet: test account[9] and salary: 1 ether should be stored and then removed.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      
      return payrollInstance.addEmployee(1, accounts[9]);
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[9]);
    }).then(function(){
      return payrollInstance.isEmployeeExist.call(accounts[9]);
    }).then(function(isExist) {
      assert.deepEqual(isExist, false, "The test account[9] with 1 ether salary was not deleted.");
    });
  });
  
});