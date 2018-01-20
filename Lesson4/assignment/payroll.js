var payroll = artifacts.require("./payroll.sol");

contract('payroll', function(accounts) {


  // add a new employee
  it("...should add a new employee.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      return payrollInstance.employees.call(employeeId);
    }).then(function(employee) {
        assert(true);
        assert.equal(employee[0], employeeId, "check employee address");
        assert.equal(employee[1].valueOf(), web3.toWei(salary, 'ether'), "check salary");
    });
  });

  // should not add a new employee by other employee
  it("...should not add a new employee by non-owner person.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: employeeId});
    }).catch(function(error) {
        assert(error);
    });
  });


  // should not add an existed employee
  it("...should not add an exisetd employee.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      // add record of employeeId -> then he/she has become an employee
      payrollInstance.employees[employeeId] = {id: employeeId, salary: salary};
      // add the same employee again -> wrong!
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).catch(function(error) {
        assert(error);
    });
  });




  // remove employee with expected behavior: add employee first and then remove
  it("...should remove the target employee.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
        // remove this employee
      return payrollInstance.removeEmployee(employeeId, {from: owner});
    }).then(function() {
        // access record of this removed employee
        return payrollInstance.employees.call(employeeId);
      }).then(function(employee) {
          // non-existed employee: address is default value "0x0"
          assert.equal(employee[0], "0x0", "non-existed employee");
          assert(true);
      });
  });

  // remove employee by person other than owner
  it("...should not remove employee by non-owner person.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      // let employee to remove self is an error!
      return payrollInstance.removeEmployee(employeeId, {from: employeeId});
    }).catch(function(error) {
        assert(error);
    });
  });

  // remove non-existed employee
  it("...should not remove non-existed employee.", function() {
    let owner = accounts[0];
    // accounts[2] has never been added as employee, try to remove is an error
    let employee = accounts[2];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.removeEmployee(employee, {from: owner});
    }).catch(function(error) {
        assert(error);
    });
  });

});
