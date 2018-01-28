var Payroll = artifacts.require("./Payroll.sol");
var employeeAddr = 0x228d2c17eb24e516167b38289d8d0730ea7c4474;

contract('Payroll', function(accounts) {
    const ownerAddress = accounts[0];
    const employeeAddr = accounts[1];
    const employeeAddr2 = accounts[2];
    
    it("add employee by non-owner", function(){
      return Payroll.deployed().then((instance) => {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employeeAddr, 1,
          {
            from:employeeAddr2
          });
      }).then(function(res){
        assert(false, "should throw error but did not");
      }).catch(function(error){
        console.log(error.toString())
        assert.notEqual(error.toString().indexOf("Exception while processing transaction"), -1, "Add same Error");
      })
    })

    it("add new employee", function(){
      return Payroll.deployed().then((instance) => {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employeeAddr, 1);
      }).then(function(){
        return  PayrollInstance.checkEmployee.call(employeeAddr);
      }).then(function(res){
        assert.equal(res[0], web3.toWei(1, 'ether'), "Add Error.");
      })
    })

    it("add same employee", function(){
      return Payroll.deployed().then((instance) => {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employeeAddr, 1);
      }).then(function(res){
        assert(false, "should throw error but did not");
      }).catch(function(error){
        assert.notEqual(error.toString().indexOf("invalid opcode"), -1, "Add same Error");
      })
    })




    it("remove employee", function(){
      return Payroll.deployed().then((instance) => {
        PayrollInstance = instance;
        return PayrollInstance.addFund({value:2000000});
      }).then(function(){
        return PayrollInstance.removeEmployee(employeeAddr);
      }).then(function(){
        return  PayrollInstance.checkEmployee.call(employeeAddr);
      }).then(function(res){
        assert.equal(res[0], 0, "Remove Error.");
      })
    })

});
