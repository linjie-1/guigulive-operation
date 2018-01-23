var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll - addEmployee', function(accounts) {

  it("should add employee correctly by owner", function(done) {
    var payroll;
    Payroll.deployed().then(instance => {
      payroll = instance;
      payroll.addEmployee(accounts[0],1, {from: accounts[0]});
    }).then( res => {
      return payroll.totalSalary.call();
    }).then( res => {
      assert.equal(res.toString(), web3.toWei(1), 'totalSalary not correct!');
      return payroll.employees.call(accounts[0]);
    }).then( res => {
      assert.equal(res[0].toString(),accounts[0],"address not added correctly!");
      assert.equal(res[1].toString(),web3.toWei(1),"salary not added correctly!");
      done();
    });
  });

  it("should not add employee because it is not the owner", function(done) {
    Payroll.deployed().then(instance => {
      instance.addEmployee(accounts[0],1, {from: accounts[1]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "owner should be checked");
        done();
      })
    });
  });

  it("should not add employee if the employee already exists", function(done) {
    Payroll.deployed().then(instance => {
      instance.addEmployee(accounts[0],1, {from: accounts[0]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "owner should be checked");
        done();
      })
    });
  });
});


contract('Payroll - removeEmployee', function(accounts) {

  it("should add employee correctly by owner", function(done) {
    var payroll;
    Payroll.deployed().then(instance => {
      payroll = instance;
      payroll.addEmployee(accounts[0],1, {from: accounts[0]});
    }).then( res => {
      return payroll.removeEmployee(accounts[0],{from:accounts[0]});
    }).then( res => {
      return payroll.totalSalary.call();
    }).then( res => {
      assert.equal(res.toString(), web3.toWei(0), 'totalSalary not correct!');
      return payroll.employees.call(accounts[0]);
    }).then( res => {
      assert.equal(res[0].toString(),'0x0000000000000000000000000000000000000000','address not correct!');
      done();
    });
  });

  it("should not remove employee because it is not the owner", function(done) {
    var payroll;
    Payroll.deployed().then(instance => {
      payroll = instance;
      payroll.addEmployee(accounts[0],1, {from: accounts[0]});
    }).then( res => {
      return payroll.removeEmployee(accounts[0],{from:accounts[1]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "owner should be checked");
        done();
      });
    });
  });

  it("should not remove employee if the employee not exists", function(done) {
    Payroll.deployed().then(instance => {
      instance.removeEmployee(accounts[3], {from: accounts[0]}).catch(error => {
        assert.include(error.toString(), "invalid opcode", "address exists should be checked");
        done();
      });
    });
  });
});
