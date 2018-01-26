var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll-addEmployee', function(accounts) {
  it("Only owner can add correctly an employee", function(done) {
    let owner = accounts[0];
    let employeeId = accounts[1];
    let salary = 1;
    var payrollInstance; 

    Payroll.deployed().then(instance =>{
      payrollInstance = instance;
      payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(res =>{
      return payrollInstance.totalSalary.call()
    }).then(res => {
      assert.equal(res.valueOf(), web3.toWei(salary, 'ether'), 'check totalSalary!');
      return payrollInstance.employees.call(employeeId);
    }).then(employee =>{
        assert.equal(employee[0].toString(), employeeId, "check employee address");
        assert.equal(employee[1].valueOf(), web3.toWei(salary, 'ether'), "check salary");
        done();
    })
  });

  it("If not owner, should not add employee", function(done){
      let adder = accounts[2];
      let employeeId = accounts[1];
      let salary = 1;
      var payrollInstance; 

      Payroll.deployed().then(instance => {
        payrollInstance = instance; 
        return payrollInstance.addEmployee(employeeId, salary, {from: adder});
      }).catch(error => {
        assert.throws(function(){
          throw error;
        }, 'Exception');
        done();
      });
  });

  it("If owner but with exist employeeId, should not add employee", function(done){
    Payroll.deployed().then(instance =>{
      let owner = accounts[0];
      let employeeId = accounts[1];
      let salary = 1;
      var payrollInstance; 

      Payroll.deployed().then(instance => {
        payrollInstance = instance;
        return payrollInstance.addEmployee(employeeId, salary, {from: owner});
      }).then(res=>{
        return payrollInstance.addEmployee(employeeId, salary, {from: owner});
      }).catch(error => {
        assert.throws(function(){
          throw error;
        }, 'Exception');
        done();
      });
    });
  });

});

contract('Payroll-removeEmployee', function(accounts) {
  it("Only owner can remove correctly an exist employee", function(done) {
    let owner = accounts[0];
    let employeeId = accounts[1];
    let salary = 1;
    var payrollInstance; 

    Payroll.deployed().then(instance =>{
      payrollInstance = instance;
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(res =>{
      return payrollInstance.removeEmployee(employeeId, {from: owner});
    }).then(res =>{
      return payrollInstance.totalSalary.call();
    }).then(res => {
      assert.equal(res.valueOf(), web3.toWei(0, 'ether'), 'check totalSalary!');
      return payrollInstance.employees.call(employeeId);
    }).then(employee =>{
        assert.equal(employee[0], '0x0000000000000000000000000000000000000000', "Not exist");
        done();
    })
  });

  it("If not owner, should not remove employee", function(done){
    let owner = accounts[0];
    let remover = accounts[2];
    let employeeId = accounts[1];
    let salary = 1;
    var payrollInstance; 

    Payroll.deployed().then(instance =>{
      payrollInstance = instance;
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(res =>{
      return payrollInstance.removeEmployee(employeeId, {from: remover});
    }).catch(error => {
      assert.throws(function(){
        throw error;
      }, 'Exception');
      done();
    });
  });

  it("If owner but with non-exist employeeId, should not remove employee", function(done){
    Payroll.deployed().then(instance =>{
      let owner = accounts[0];
      let employeeId = accounts[1];
      let removeEmployeeId = accounts[2];
      let salary = 1;
      var payrollInstance; 

      Payroll.deployed().then(instance => {
        payrollInstance = instance;
        return payrollInstance.addEmployee(employeeId, salary, {from: owner});
      }).then(res=>{
        return payrollInstance.removeEmployee(removeEmployeeId, {from: owner});
      }).catch(error => {
        assert.throws(function(){
          throw error;
        }, 'Exception');
        done();
      });
    });
  });
});
