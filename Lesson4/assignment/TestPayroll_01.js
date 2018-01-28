var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it(" add an employee.", function(accounts) {

    return Payroll.deployed().then(function(instance) {
      
      payrollInstance = instance;
      console.log("add an employee");
      return payrollInstance.addEmployee(accounts[0],1);
    }).then(function() {
      assert(true, "The employee was added.");
    });
  });

  it(" add an employee again.", function(accounts) {
    
        return Payroll.deployed().then(function(instance) {
          
          payrollInstance = instance;
          console.log("add an employee again");
          return payrollInstance.addEmployee(accounts[1],1);
        }).then(function() {
    
          assert(true, "The second employee was added.");
        });
  });

  it("Delete an employee!", function(accounts) {
    
        return Payroll.deployed().then(function(instance) {
           payrollInstance = instance;
           console.log("delete an employee");
           return payrollInstance.removeEmployee(accounts[1]);
        }).then(function() {
           assert(true, "The employee was deleted.");
        });
  });


});
