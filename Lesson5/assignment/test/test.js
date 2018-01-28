var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  var owner = accounts[0];
  var employeeId = accounts[1];
  var salary = 1;

  it("should add a new employee.", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;

      return PayrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
        return PayrollInstance.employees.call(employeeId);
    }).then(function(newEmployee) {
        assert.equal(newEmployee[0], employeeId, "check employee address.");
        assert.equal(newEmployee[1].valueOf(), web3.toWei(salary, 'ether', "check employee salary."));
    }).then(function() {
      return PayrollInstance.totalSalary.call();
    }).then(function(totalSalary) {
      assert.equal(totalSalary.valueOf(), web3.toWei(salary, 'ether'), "check total salary.");
    });
  });

  it("should not add employee without owner", function() {
    return Payroll.deployed().then(function(instance) {
        return instance.addEmployee(employeeId, salary, {from: accounts[2]});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        },
        'VM Exception while processing transaction: invalid opcode');
    });
  });

  it("should not add the same employee twice", function() {
    return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
        PayrollInstance.employees[employeeId] = {id: employeeId, salary: salary};
    }).then(function() {
        return PayrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        },
        'VM Exception while processing transaction: invalid opcode');
    });
  });

  it("should remove an employee.", function() {
    var employeeId = accounts[2];

    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;

      return PayrollInstance.addFund.call({value: web3.toWei(100, 'ether')});
    }).then(function() {
      return PayrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      return PayrollInstance.removeEmployee(employeeId, {from: owner});
    }).then(function() {
        return PayrollInstance.employees.call(employeeId);
    }).then(function(employee) {
        assert.equal(employee[0], "0x0000000000000000000000000000000000000000", "check employee address.");
    }).then(function() {
      return PayrollInstance.totalSalary.call();
    }).then(function(totalSalary) {
      assert.equal(totalSalary.valueOf(), web3.toWei(salary, 'ether'), "check total salary.");
    });
  });

  it("should not remove employee without owner", function() {
    return Payroll.deployed().then(function(instance) {
        return instance.removeEmployee(employeeId, {from: accounts[2]});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        },
        'VM Exception while processing transaction: invalid opcode');
    });
  });

  it("should not remove employee that isn't exist", function() {
    return Payroll.deployed().then(function(instance) {
        return instance.removeEmployee(accounts[3], {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        },
        'VM Exception while processing transaction: invalid opcode');
    });
  });
});