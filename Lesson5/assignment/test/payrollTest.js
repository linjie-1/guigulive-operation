var Payroll = artifacts.require('./Payroll.sol');

contract('Payroll' ,function(accounts) {
    var address = '0xed6ecb4188e27db4133740cb4bd4ff3c3452ea7a';
    
    it('add employee  ',function() {
        return Payroll.deployed().then(function(instance) {
            PayrollInstance = instance;
            PayrollInstance.addEmployee(address,1);
            return PayrollInstance;
          }).then(function() {
              return  PayrollInstance.isEmployeeExist.call(address);
            }).then( function(result){
            console.log('result:'+result);
            assert(result,  'add fail')
          }) ;
    }) ;
 
    it('remove employee  ',function() {
        return Payroll.deployed().then(function(instance) {
            PayrollInstance = instance;
            return PayrollInstance.removeEmployee(address);
        }).then(function() {
              return PayrollInstance.isEmployeeExist.call(address);
           }).then( function(result){
            console.log('result:'+result);
            assert(!result,  'remove fail')
          }) ;
    }) ;
 
});