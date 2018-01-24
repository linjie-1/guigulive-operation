var Payroll = artifacts.require('./Payroll.sol');

contract('Payroll', function(accounts) {
    
    // add a new employee  
    it("should add a new employee correctly", function() {
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(accounts[1], 1);
        }).then(function() {
            return payroll.employees.call(accounts[1]);
        }).then(function(employee) {
            assert.equal(employee[0], accounts[1], 'Added employee has wrong id');
            assert.equal(employee[1].valueOf(), web3.toWei(1), 'ether', 'Added employee has wrong salary');
        });
    });


    // remove an existing employee
    it("should remove an existing employee correctly", function() {
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(accounts[2], 2);
        }).then(function() {
            return payroll.removeEmployee(accounts[2]);
        }).then(function(removedEmployee) {
            assert.equal(payroll.employees[accounts[2]], undefined, 'The employee hasn\`t been removed.');
        });
    });

}) 