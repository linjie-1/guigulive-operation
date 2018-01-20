var PayRoll = artifacts.require("./Payroll.sol");

contract('PayRoll', function (accounts) {
  

  // addEmployee
  it("...add emoloyee successfully.", function () {
      return PayRoll.deployed().then(function (instance) {
          payrollInstance = instance;
      }).then(function(){
        return payrollInstance.addFund({value: web3.toWei(50)});
      }).then(function(){
        return payrollInstance.addEmployee(accounts[1], 2);
      }).then(function(){
        return payrollInstance.employees.call(accounts[1]);
      }).then(function(employee){
        assert.equal(employee[1].valueOf(), web3.toWei(2), "fail");
      });
    });
  
  //  removeEmployee
  it("...remove employee successfully.", function() {
    return PayRoll.deployed().then(function (instance) {
      payrollInstance = instance;
    }).then(function() {
      return payrollInstance.addEmployee(accounts[2], 5);
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[2]);
    }).then(function() {
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(employee) {
      assert.equal(employee[0].valueOf(), 0x0, "fail")
    })
  });
}); 