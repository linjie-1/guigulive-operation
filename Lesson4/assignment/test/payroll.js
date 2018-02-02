// var async = require("async");

// I am trying to use zeppelin-solidity increaseTime helper here, but failed.
// function increaseTime (duration) {
//   const id = Date.now();
//
//   return new Promise((resolve, reject) => {
//     web3.currentProvider.sendAsync({
//       jsonrpc: '2.0',
//       method: 'evm_increaseTime',
//       params: [duration],
//       id: id,
//     }, err1 => {
//       if (err1) return reject(err1);
//
//       web3.currentProvider.sendAsync({
//         jsonrpc: '2.0',
//         method: 'evm_mine',
//         id: id + 1,
//       }, (err2, res) => {
//         return err2 ? reject(err2) : resolve(res);
//       });
//     });
//   });
// }
//
// duration = {
//   seconds: function (val) { return val; },
//   minutes: function (val) { return val * this.seconds(60); },
//   hours: function (val) { return val * this.minutes(60); },
//   days: function (val) { return val * this.hours(24); },
//   weeks: function (val) { return val * this.days(7); },
//   years: function (val) { return val * this.days(365); },
// };

const Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  describe('TestAddEmployee', function(){
    var testEmployeeId = accounts[5];
    var testEmployeeId2 = accounts[6];

    it("should add employee and set salary successfully.", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.getTotalSalary.call({from: accounts[0]});
      }).then(function(totalSalary){
        oldTotalSalary = totalSalary;
        return payroll.addEmployee(testEmployeeId, 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(testEmployeeId);
      }).then(function(result) {
        assert.equal(result[0].toNumber() /* salary */, web3.toWei(1, "ether"), "The employee should have been added and salary is set to 1 ether.");
      }).then(function(){
        return payroll.getTotalSalary.call({from: accounts[0]});
      }).then(function(totalSalary){
        assert.equal(oldTotalSalary, totalSalary - web3.toWei(1, "ether"), "Add employee should also increase total salary employer needs to pay");
      });
    });

    it("should not add duplicate employee", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(testEmployeeId, 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(testEmployeeId);
      }).then(function(result) {
        return payroll.addEmployee(testEmployeeId, 1, {from: accounts[0]});
      }).catch(function(err){
        assert.isNotNull(err, "An employee can not be added more than once!");
      });
    })

    it("should only allow owner to add employee", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;

        return payroll.addEmployee(testEmployeeId, 1, {from: accounts[1]});
      }).then(function(result) {
        assert(false);
      }).catch(function(err) {
        assert.isNotNull(err, "only owner can add employee");
      });
    });
  });

  describe('TestRemoveEmployee', function(){
    var testEmployeeId = accounts[5];
    var testEmployeeId2 = accounts[6];

    it("should remove employee and reduce total salary successfully.", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(testEmployeeId2, 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(testEmployeeId2, {from: accounts[0]});
      }).then(function(result) {
        return payroll.getTotalSalary.call({from: accounts[0]});
      }).then(function(totalSalary){
        oldTotalSalary = totalSalary;
        return payroll.removeEmployee(testEmployeeId2, {from: accounts[0]});
      }).then(function(result){
        return payroll.getTotalSalary.call({from: accounts[0]});
      }).then(function(totalSalary){
        assert.equal(oldTotalSalary - web3.toWei(1, "ether"), totalSalary, "Removing employee should reduce total salary employer needs to pay");
        return payroll.checkEmployee.call(testEmployeeId2, {from: accounts[0]});
      }).then(function(result){
        assert.notEqual(result[0].toNumber(), web3.toWei(1, "ether"), "Employee has been deleted");
      });
    });

    it("should only allow owner to remove employee", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(testEmployeeId2, 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(testEmployeeId2, {from: accounts[0]});
      }).then(function(result) {
        return payroll.removeEmployee(testEmployeeId2, {from: accounts[1]});
      }).then(function(result){
      }).catch(function(err){
        assert.isNotNull(err, "Only owner can remove employee");
      });
    });

    it("should check employee existence before removing", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.removeEmployee(testEmployeeId2, {from: accounts[0]});
      }).then(function(result){
      }).catch(function(err){
        assert.isNotNull(err, "Employee does not exist in the contract");
      });
    });
  });

  describe("TestGetPaid", function(){
    var testEmployeeId = accounts[5];
    var testEmployeeId2 = accounts[6];

    it("should check employee existence before paying salary", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.getPaid({from: accounts[1]});
      }).then(function(result){
      }).catch(function(err){
        assert.isNotNull(err, "Employee does not exist in the contract");
      });
    });

    it("should pay employee after the promised time period", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(accounts[2], 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(accounts[2], {from: accounts[0]});
      }).then(function(result) {
        return payroll.addFund({from: accounts[0], value: web3.toWei('10', 'ether')});
      }).then(function(result){
        oldBalance = web3.fromWei(web3.eth.getBalance(accounts[2]), 'ether').toNumber();
        sleep(10000).then(function(){
          return payroll.getPaid({from: accounts[2]});
        }).then(function(result){
          newBalance = web3.fromWei(web3.eth.getBalance(accounts[2]), 'ether').toNumber();
          assert.equal(newBalance - oldBalance, 1, "employee is paid successfully");
        });
      });

      // const employee = accounts[1];
      // const before_paid = new BigNumber(web3.eth.getBalance(employee));
      // try {
      //   const pay_duration = await payroll.payDuration();
      //   // Increase next block's timestamp with 2 * payDuration.
      //   web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [ 2 * pay_duration ], id: 1});
      //   web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 2});
      //   let result = await payroll.getPaid({from : employee});
      //   var gasPrice = web3.eth.getTransaction(result.tx).gasPrice.toNumber();
      //   // Get gas consumed by function getPaid().
      //   // See https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethestimategas:
      //   // Executes a message call or transaction, which is directly executed in
      //   // the VM of the node, but never mined into the blockchain.
      //   let gas = await payroll.getPaid.estimateGas({from : employee});
      //
      //   const after_paid = new BigNumber(web3.eth.getBalance(employee));
      //   assert.equal(base_salary, after_paid.minus(before_paid).plus(gasPrice * gas).toString());
      // } catch (err) {
      //   console.log("await promise error: ", err);
      // }
    });

    it("should not pay employee if employee has not worked long enough", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(accounts[1], 1, {from: accounts[0]});
      }).then(function(result) {
        return payroll.checkEmployee.call(accounts[1], {from: accounts[0]});
      }).then(function(result) {
        return payroll.addFund({from: accounts[0], value: web3.toWei('10', 'ether')});
      }).then(function(result){
        return payroll.getPaid({from: accounts[1]});
      }).then(function(result){
      }).catch(function(err){
        assert.isNotNull(err, "Employee has not worked long enough for next pay");
      });
    });
  });
});

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
