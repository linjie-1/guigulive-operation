var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("add employee as owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      newGuy = web3.personal.newAccount();
      return payrollInstance.addEmployee(newGuy,1);
    }).then(function(g) {
      return payrollInstance.checkEmployee.call(newGuy);
    }).then(function(ans){  
        console.log(ans);
        assert.equal(ans[0].c[0], 10000, "salary is mismatcehd");
    });
  });

  it("remove employee as owner", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      newGuy = web3.personal.newAccount();
      return payrollInstance.addEmployee(newGuy,1);
    }).then(function(g) {
      return payrollInstance.checkEmployee.call(newGuy);
    }).then(function(ans){  
      assert.equal(ans[0].s, 1, "salary is mismatcehd"); //prove employee is added
    }).then(function(){
      return payrollInstance.removeEmployee(newGuy);
    }).then(function(){
      return payrollInstance.checkEmployee.call(newGuy);
    }).then(function(ans){
      console.log(ans);
      assert.equal(ans[0].c[0], 0, "salary should be 0!");
    });
  });
});
