<<<<<<< HEAD
var Payroll = artifacts.require("./Payroll.sol");
contract('Payroll', (accounts) => {
  it("should be able to add a valid employee with salary.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addFund({value: web3.toWei(10)});
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.employees.call(accounts[1]);
    }).then((employeeData) => {
      assert.equal(employeeData[1].valueOf(), web3.toWei(2), "Employee not stored with salary 1.");
    });
  });




  it("should be able to remove an existing employee after paying owed salary.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      
      return PayrollInstance.addFund({value: web3.toWei(10)});
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[2], 2);
    }).then(() => {
      return PayrollInstance.employees.call(accounts[2]);
    }).then((employeeData) => {
       return PayrollInstance.removeEmployee(accounts[2]);
    }).then(() => {
      return PayrollInstance.employees.call(accounts[2]);
    }).then((employeeData) => {
       assert.equal(employeeData[0].valueOf(), 0x0, "Employee not removed.");
    });
  });
});
=======
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
>>>>>>> master
