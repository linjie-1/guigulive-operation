var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  var payroll;
  var boss = accounts[0];
  var emp1 = accounts[1];
  var emp2 = accounts[2];

  before(function () {
    payroll = Payroll.new(boss);
    payroll.then(function (ins) {
      ins.addFund({from: boss, value: web3.toWei(10, "ether")});
    });
  })

  it("Add employee", function () {
    var pr;
    return payroll.then(function (ins) {
      pr = ins;
      return pr.bossAddEmployee(emp1, 1, 1, {from: emp2});
    }).then(function (res) {
      assert.equal(res.receipt.status, 0, "Transaction should fail. Emoloyee should not be added by people who are not the boss");
    }).then(function () {
      return pr.bossAddEmployee(emp1, 1, 1, {from: boss});
    }).then(function (res) {
      assert.equal(res.receipt.status, 1, "Transaction should be successfull");
      return pr.employees.call(emp1);
    }).then(function(res) {
      assert.equal(res[0], web3.toWei(1, "ether"), "Boss should be able to add a valid employee and added employee shouold be in the list");
    }).catch(function (err) {
      console.log(err);
      assert.fail("should not trigger any error");
    });
  });

  it("Remove Employee", function () {
    var pr;

    return payroll.then(function (ins) {
      pr = ins;
      return pr.removeEmployee(emp1, {from: emp2});
    }).then(function (res) {
      assert.equal(res.receipt.status, 0, "Transaction should be failed when the employee is not removed by the boss");
      return pr.removeEmployee(emp2, {from: boss});
    }).then(function (res) {
      assert.equal(res.receipt.status, 0, "Transaction should be failed when the employee is not valid");
      return pr.removeEmployee(emp1, {from: boss});
    }).then(function (res) {
      assert.equal(res.receipt.status, 1, "Transaction should be successfull when the employee is valid");
    });
  });
});
