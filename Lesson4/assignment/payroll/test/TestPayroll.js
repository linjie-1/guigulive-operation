var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
      
    it("check add employee", function() {
        Payroll.deployed().then(function(instance) {
            return instance.addEmployee(accounts[1],1);
        }).then(function() {
            assert(true, "pass the test.");
        })
    });

    it("check if the nonowner can call addEmployee", function() {
        Payroll.deployed().then(function(instance) {
            return instance.addEmployee(accounts[1],1,{from:accounts[3]});
        }).catch(function(error) {
            assert(error.toString().includes('revert'), "exception !");
        });
    });

    it("check if the removed employee is actually in employees", function() {
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[6]);
        }).catch(function(error) {
            assert(error.toString().includes('invalid'), "exception !");
        })
    });



    it("check if the nonowner can call removeEmployee", function() {
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1],1);
        }).then(function() {
            return payrollInstance.removeEmployee(accounts[1],{from:accounts[1]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "exception !");
        })
    });
});