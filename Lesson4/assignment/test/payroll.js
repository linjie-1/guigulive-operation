// - 在test文件夹中，写出对如下两个函数的单元测试：
// - function addEmployee(address employeeId, uint salary) onlyOwner
// - function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)

var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll_1', function(accounts) {

  it("...should add employee by owner", function(done) {
    Payroll.deployed().then((instance) => {
      payrollInstance = instance;
      payrollInstance.addEmployee(accounts[0], 1, {from: accounts[0]});
      return payrollInstance.employees.call(accounts[0]);
    }).then((employee) => {
      employeeid = employee[0]
      salary = employee[1]
      assert.equal(employeeid.toString(), accounts[0], 'Address not created correctly');
      assert.equal(salary.valueOf(), web3.toWei(1, 'ether'), 'Salary not created correctly');
      done();
    });
  });

  it("...should not add employee by others except owner", function(done) {
    Payroll.deployed().then((instance) => {
      instance.addEmployee(accounts[1], 1, {from: accounts[1]}).catch(error =>{
        assert.include(error.toString(), "revert", "owner should be checked")
        done();
      });
    });
  });

  it("...should not add an existed employee by owner", function(done) {
    Payroll.deployed().then((instance) => {
      instance.addEmployee(accounts[0], 1, {from: accounts[0]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "address existence should be checked")
        done();
      });
    });
  });

});

contract('Payroll_2', function(accounts) {

  it('...should remove by onwner', function(done) {
    Payroll.deployed().then((instance) => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[3], 1, {from: accounts[0]});
    }).then((res) => {
      return payrollInstance.removeEmployee(accounts[3], {from: accounts[0]});
    }).then((res) => {
      return payrollInstance.employees.call(accounts[3]);
    }).then((employee) => {
      employeeid = employee[0]
      salary = employee[1]
      assert.equal(employeeid.toString(), '0x0000000000000000000000000000000000000000', 'Address not removed correctly');
      assert.equal(salary.valueOf(), web3.toWei(0, 'ether'), 'Salary not removed correctly');
      done();
    });
  });

  it('...should not remove by others except owner', function(done) {
    Payroll.deployed().then((instance) => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[4], 1, {from: accounts[0]});
    }).then((res) => {
      payrollInstance.removeEmployee(accounts[4], {from: accounts[1]}).catch(error => {
        assert.include(error.toString(), "revert", "owner should be checked");
        done();
      });
    });
  });

  it('...should not remove unexisted employee by owner', function(done) {
    Payroll.deployed().then((instance) => {
      instance.removeEmployee(accounts[5], {from: accounts[0]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "address existence should be checked");
        done();
      });
    });
  });

});
