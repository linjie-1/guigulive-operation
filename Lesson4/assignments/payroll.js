var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Payroll Add Employee Test", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee("0xa7d4e8f8f28ad94a1b778db457274424d575f3a3", 2);
    }).then(function() {
      return payrollInstance.employees.call(["0xa7d4e8f8f28ad94a1b778db457274424d575f3a3"]);
    }).then(function(x) {
      console.log('id=' + x[0])
      assert.equal(x[0], "0xa7d4e8f8f28ad94a1b778db457274424d575f3a3",
      "0xa7d4e8f8f28ad94a1b778db457274424d575f3a3 was not stored");
    });
  });

  it("Payroll Remove Employee Test", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee("0xa7d4e8f8f28ad94a1b778db457274424d575f3a4", 2);
    }).then(function() {
      return payrollInstance.employees.call(["0xa7d4e8f8f28ad94a1b778db457274424d575f3a4"]);
    }).then(function(x) {
      console.log('id=' + x[0])
      
      return x[0]
    }).then(function(id){
      console.log('id to remove' + id);
      payrollInstance.removeEmployee("0xa7d4e8f8f28ad94a1b778db457274424d575f3a4");
    }).then(function(){
        payrollInstance.employees.call("0xa7d4e8f8f28ad94a1b778db457274424d575f3a4").then(
            function(x){
                assert.equal(x, "0x0", "0xa7d4e8f8f28ad94a1b778db457274424d575f3a4 should be removed");
            }
        );

    });
  });

});
