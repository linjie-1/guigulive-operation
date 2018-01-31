var PayRoll = artifacts.require("./Payroll.sol");

contract('PayRoll', function (accounts) {
  

  // addEmployee
  it("...add emoloyee successfully.", function () {
      return PayRoll.deployed().then(function (instance) {
          payrollInstance = instance;
      }).then(function(){
        return payrollInstance.sendTransaction({value:web3.toWei(1, "ether")});
      }).then(function(){
        return payrollInstance.addEmployee("0x123", 1);
      }).then(function() {
        return payrollInstance.getEmployeeSalary.call("0x123");
      })
      .then(function(salary){
        assert.equal(salary, 1, "fail");
      });
    });
  
  //  removeEmployee
  it("...remove employee successfully.", function() {
    return PayRoll.deployed().then(function (instance) {
      payrollInstance = instance;
    }).then(function(){
      return payrollInstance.sendTransaction({value:web3.toWei(1, "ether")});
    }).then(function() {
      return payrollInstance.addEmployee(accounts[2], 5);
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[2]);
    }).then(function() {
      return payrollInstance.getEmployeeSalary.call(accounts[2]);
    })
    .then(function(salary) {
      assert.equal(salary, 0, "fail");
    });
  });
}); 