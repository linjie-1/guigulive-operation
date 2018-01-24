var payroll = artifacts.require("./payroll.sol");
// var accounts = web3.eth.accounts;
// var employee1 = accounts[1];
var address = '0xed6ecb4188e27db4133740cb4bd4ff3c3452ea7a';
var salary = 2;

contract('payroll', function(accounts) {

    it("...should add an empolyee", function() {
       return payroll.deployed().then(function(instance) {
        payrollinstance = instance;
        payrollinstance.addEmployee(address,salary);
        console.log('payrollinstance:'+payrollinstance);
        return payrollinstance; 
            }).then(function() {
        return  PayrollInstance.isEmployeeExist(address);            
        }).then(function(result) {
        assert(result, "employee add error");
            });
        });


    it("...should remove an empolyee", function(accounts) {
        return payroll.deployed().then(function(instance) {
            payrollinstance = instance;
            return payrollinstance.addFund();
             }).then(function() {
            return payrollinstance.removeEmployee(address);
            }).then(function() {
                return  payrollinstance.employees.call(address);
            }).then( function(result){
                assert.equal(!result, "employee remove error");
            });

    });
  
//     it('remove employee ',function() { 
//   return payroll.deployed().then(function(instance) { 
//   PayrollInstance = instance; 
//   return PayrollInstance.removeEmployee(employee1); 
//   }).then(function() { 
//   return PayrollInstance.isEmployeeExist.call(employee1); 
//   }).then( function(result){ 
//   console.log('result:'+result); 
//   assert(!result, 'remove fail') 
//   }) ; 
//   }) ; 
    

});
