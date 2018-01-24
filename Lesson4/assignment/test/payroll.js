var Payroll = artifacts.require("./payroll.sol");

contract('Payroll', function(accounts) {
    it("should add an employee correctly by owner", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).then(function(result) {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(result) {
            assert.equal(result[0], accounts[1], "employee.id is incorrect");
            assert.equal(result[1].toString(), "1000000000000000000", "employee.salary is incorrect");
            done();
        });
    });

    it("should not add employee correctly by others", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[2], 1, {from: accounts[1]});
        }).catch(function(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
            done();
        });
    });

    it("should not add employee with same id", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
            done();
        });
    });

    it("should remove an employee by owner", function(done){
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        }).then(function(result) {
            return payrollInstance.employees.call(accounts[1]);
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
            return payrollInstance.removeEmployee(accounts[2], {from: accounts[1]});
        }).catch(function(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
            done();
        });
    });

    it("should not remove employee with id 0x0", function(done) {
        let payrollInstance;
        Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        }).catch(function(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
            done();
        });
    });
});
