var payroll = artifacts.require("./payroll.sol");

contract('payroll', function(accounts) {
    var accounts = web3.eth.accounts;
    var employee = accounts[1];
    var salary = 5;

    it("Add employee", function() {
       return payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(employee,salary);
            }).then(function() {
        return payroll.employees.call(employee);
            }).then(function(result) {
        assert.equal(result.valueOf(), web3.toWei(salary, 'ether'), "addEmployee Error!");
            });
        });
    
    it("Remove employee", function() {
        return Payroll.deployed().then(function(instance) {
             instance.removeEmployee(employee);
             return instance.getEmployee(employee);	
        }).then(function(result) {
            assert.equal(result.valueOf(), 0, "removeEmployee Error!");
         });
     });	    
});