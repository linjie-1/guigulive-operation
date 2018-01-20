var Payroll = artifacts.require("./Payroll.sol");
var testaddr = '5454232323232323';
var testaddr2 = '0xf17f52151EbEF6C7334FAD080c5704D77216333';
contract('Payroll', function(accounts) {

  it("...test payroll", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
      console.log('我是luz..创建了合约....');
      console.log('我要添加测试钱包2:');
      return payrollInstance.addEmployee(testaddr2, 22);
    }).then(function() {
        console.log('查看我的余额:');
        return payrollInstance.removeEmployee(testaddr2);
    }).then(function() {
        console.log("成功..");
        // assert.equal("The value 89 was not stored.");
    });
  });

});
