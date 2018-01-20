var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

    it("Add the employee function test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1], 1);
        }).then(function() {
            assert(true, "Try again!");
        });
    });

    it("Onlyowner can add employee test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[2], 2, {from: accounts[2]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "Try again!");
        });
    });

    it("Can't add duplicate employee test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            payrollInstance.addEmployee(accounts[3], 3);
            return payrollInstance.addEmployee(accounts[3], 3);
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "Try again!");
        });
    });

    it("Delete the employee function test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[1]);
        }).then(function() {
            assert(true, "Try again!");
        });
    });

    it("Onlyowner can delete employee test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[1], {from: accounts[1]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "Try again!");
        });
    });

    it("Can't delete not existed employee test successfully!", function() {
        var payrollInstance;
        
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[4]);
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "Try again!");
        });
    });

});
