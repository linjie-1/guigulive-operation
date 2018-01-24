var payroll = artifacts.require("./payroll.sol");
var accounts = web3.eth.accounts;
var employee1 = accounts[1];
var salary = 2;

contract('payroll', function(accounts) {

    it("...should add an empolyee", function() {
       return payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(employee1,salary);
            }).then(function() {
        return payroll.employees.call(employee1);
            }).then(function(storedData) {
        assert.equal(storedData[1].valueOf(), web3.toWei(2), "The employee's salary is not 2 ether.");
            });
        });

});
