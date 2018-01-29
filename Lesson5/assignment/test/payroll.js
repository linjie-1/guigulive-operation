var payroll = artifacts.require("./payroll.sol");
// var accounts = web3.eth.accounts;
// var employee1 = accounts[1];
var address = '0xed6ecb4188e27db4133740cb4bd4ff3c3452ea7a';
var salary = 2;

contract('payroll', function(accounts) {

    it("...should add an empolyee", function() {
       return payroll.deployed().then(function(instance) {
        payroll = instance;
         payroll.addEmployee(address,salary);
         return payroll;
            }).then(function() {
        return payroll.employees.call(address);
            }).then(function(storedData) {
        assert.equal(storedData[1], web3.toWei(2), "The employee's salary is not 2 ether.");
        });
    });
     it('remove employee ',function() { 
        return payroll.deployed().then(function(instance) { 
        PayrollInstance = instance; 
        return PayrollInstance.removeEmployee(address); 
        }).then(function() { 
         return PayrollInstance.isEmployeeExist.call(address); 
        }).then( function(result){ 
         console.log('result:'+result); 
        assert(!result, 'remove fail') 
         }) ; 
        }) ; 
});
  

    


