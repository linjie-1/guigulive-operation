var Payroll = artifacts.require('./Payroll.sol');

contract('Payroll', function(accounts) {
    var payroll;
    var owner = accounts[0];
    var salary = 1;

    // add fund   
    it("should add fund", function() {
        return Payroll.deployed().then(function(instance) {
            return instance.addFund.call({value: web3.toWei(1000, 'ether'), from: owner});
        }).then(function(balance) {
            assert.ok(true);
            assert.equal(balance.toNumber(), web3.toWei(1000, 'ether'));          
        });
    });
    
    // add employee  
    it("should add a new employee", function() {
        let employeeId = accounts[1];
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(employeeId, salary, {from: owner});
        }).then(function() {
            return payroll.employees.call(employeeId);
        }).then(function(newEmployee) {
            assert.ok(true, 'add employee success');
            assert.equal(newEmployee[0], employeeId, 'check employee address');
            assert.equal(newEmployee[1].valueOf(), web3.toWei(salary, 'ether'), 'check employee salary');
        });
    });

    it("should not add employee by other employees", function() {
        let employeeId = accounts[1];
        return Payroll.deployed().then(function(instance) {
            return instance.addEmployee(employeeId, salary, {from: accounts[1]});
        }).catch(function(error) {
            assert.throws(function() {
                throw error;
            },
            'VM Exception while processing transaction: invalid opcode');
        });
    });

    it("should not add an employee twice", function() {
        let employeeId = accounts[2];
        return Payroll.deployed().then(function(instance) {
            instance.employees[employeeId] = {id: employeeId, salary: salary};
            return instance.addEmployee(employeeId, salary, {from: owner});
        }).catch(function(error) {
            assert.throws(function() {
                throw error;
            },
            'VM Exception while processing transaction: invalid opcode');
        });
    });

    // remove employee
    it("should remove an employee", function() {
        let employeeId = accounts[3];
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(employeeId, salary, {from: owner});
        }).then(function() {
            return payroll.removeEmployee(employeeId, {from: owner});
        }).then(function(removedEmployee) {
            assert.ok(true);
            assert.equal(payroll.employees[employeeId], undefined);
        });
    });

    it("should not remove an employee by other employees", function() {
        let employeeId = accounts[3];
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(employeeId, salary, {from: owner});
        }).then(function() {
            return payroll.removeEmployee(employeeId, {from: accounts[1]});
        }).catch(function(error) {
            assert.throws(function() {
                throw error;
            },
            'VM Exception while processing transaction: invalid opcode');
        });
    });

    it("should not remove an employee is not existed", function() {
        return Payroll.deployed().then(function(instance) {
            return instance.removeEmployee('0x0', {from: owner});
        }).catch(function(error) {
            assert.throws(function() {
                throw error;
            },
            'VM Exception while processing transaction: invalid opcode');
        });
    });
})
