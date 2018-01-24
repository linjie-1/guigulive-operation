/*作业请提交在这个目录下*/

// 1/2 检验是否只有owner才可以增加或者移除成员函数
// 3/4 检验重复和不存在成员的添加和移除函数

var payroll = artifacts.require("./Payroll.sol");

contract('payroll', function(accounts) {

  // 1. only owner can add new employee
  it("... testing only owner can add new employee", function() {
    
    let owner = accounts[0];
    let employeeId = accounts[1];
    let salary = 100;  

    return payroll.deployed().then(function(instance){
      payrollInstance = instance;
      return payrollInstance.addEmployee(employeeId, salary, {from: employeeId});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });

  // 2. only owners can remove
  it("...testing only owners can remove.", function() {

    let owner = accounts[0];
    let employeeId = accounts[1];
    let salary = 100;  
    
    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      return payrollInstance.removeEmployee(employeeId, {from: employeeId});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });

  // 3. test duplicate employee
  it("... testing duplicate employee", function() {
    
    let owner = accounts[0];  
    let employeeId = accounts[1];
    let salary = 1;   

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.employees[employeeId] = {id: employeeId, salary: salary};
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });

  // 4. can't remove someone who is not employee
  it("... testing removing ghost.", function() {

    let owner = accounts[0];
    let ghost = accounts[3];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(ghost, {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });
});
