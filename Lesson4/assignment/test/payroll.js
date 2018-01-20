var Payroll = artifacts.require("./payroll.sol");

contract('Payroll', function(accounts) {
    it("should add an employee correctly by owner", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee("0xc42d7e5be797195e736683fd7624936f2537ed14", 1, {from: accounts[0]});
        }).then(function(result) {
            return payrollInstance.employees.call("0xc42d7e5be797195e736683fd7624936f2537ed14");
        }).then(function(result) {
            assert.equal(result[0], "0xc42d7e5be797195e736683fd7624936f2537ed14", "employee.id is incorrect");
            assert.equal(result[1].toString(), "1000000000000000000", "employee.salary is incorrect");
            done();
        });
    });

    it("should not add employee correctly by others", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee("0x99f3dda6472658b0a5fdd7d6482b220aeea5cf0c", 1, {from: "0xc42d7e5be797195e736683fd7624936f2537ed14"});
        }).catch(function(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
            done();
        });
    });

    it("should not add employee with same id", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee("0xc42d7e5be797195e736683fd7624936f2537ed14", 1, {from: accounts[0]});
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
            done();
        });
    });

    it("should remove an employee by owner", function(done){
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee("0xc42d7e5be797195e736683fd7624936f2537ed14", {from: accounts[0]});
        }).then(function(result) {
            return payrollInstance.employees.call("0xc42d7e5be797195e736683fd7624936f2537ed14");
        }).then(function(result) {
            assert.equal(result[0], "0x0000000000000000000000000000000000000000", "employee.id is incorrect");
            assert.equal(result[1].toString(), "0", "employee.salary is incorrect");
            done();
        });
    })

    it("should not remove employee correctly by others", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee("0x99f3dda6472658b0a5fdd7d6482b220aeea5cf0c", {from: "0xc42d7e5be797195e736683fd7624936f2537ed14"});
        }).catch(function(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
            done();
        });
    });

    it("should not remove employee with id 0x0", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee("0xc42d7e5be797195e736683fd7624936f2537ed14", {from: accounts[0]});
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
            done();
        });
    });
});
