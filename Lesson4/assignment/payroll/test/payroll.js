var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

//TEST addFund

  it("...should addFund", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      PayrollInstance.addFund({value:10000000000000000000})  //10 eth = 10000000000000000000  
      return PayrollInstance.addFund.call({value:0})   
    }).then(function(returnData) {
      //console.log(JSON.parse(returnData));
      assert.equal(JSON.parse(returnData), 10000000000000000000, "Fund added");
    });
  });


//TEST addEmployee()

  it("...should not add employee, if not owner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1,{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "shall not add");
    });
  });

  it("...should add new employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).then(function() {
      return PayrollInstance.employees(accounts[1]);
    }).then(function(returnData) {
      assert.equal(returnData[0], accounts[1], "The new employee added");
    });
  });

  it("...should not add employee, if already exist", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1],1);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "The employee already exist");
    });
  });

 

  //TEST getPaid() with evm_increaseTime ref:
  //https://ethereum.stackexchange.com/questions/15101/how-to-use-the-testrpc-evm-increasetime-parameter-from-truffle-console/21515
  //https://medium.com/@angellopozo/testing-solidity-with-truffle-and-async-await-396e81c54f93
  
  const displayCurrentTime = function() {
    console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
  }

  it("...should pay employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      currentBalance = web3.eth.getBalance(accounts[1]).toNumber();
      //displayCurrentTime();
      return  web3.currentProvider.send({
        jsonrpc: "2.0", 
        method: "evm_increaseTime", 
        params: [100], id: 0
      });
    }).then(function(returnData) {
      return web3.eth.sendTransaction({from: web3.eth.accounts[0]});
    }).then(function(returnData) {
      //displayCurrentTime();
      return PayrollInstance.getPaid({from:accounts[1]});
    }).then(function(returnData) {
      // console.log(currentBalance);
      // console.log(web3.eth.getBalance(accounts[1]).toNumber());
      assert(web3.eth.getBalance(accounts[1]).toNumber() > currentBalance, "employee get paid");
    });
  });


  //TEST removeEmployee()
  it("...should not remove employee, if not owner", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      //add first
      return PayrollInstance.addEmployee(accounts[2],1);
    }).then(function() {
      return PayrollInstance.removeEmployee(accounts[2],{from:accounts[1]});
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "shall not remove");
    });
  });


  it("...should remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[2]);
    }).then(function(returnData) {
      return PayrollInstance.employees(accounts[2]);
    }).then(function(returnData) {
      assert.equal(returnData[0], '0x0000000000000000000000000000000000000000', "Employee removed");
    });
  });

  it("...error if employee not exist", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      return PayrollInstance.removeEmployee(accounts[2]);
    }).catch(function(error) {
      assert(error.toString().includes('invalid'), "can't remove again");
    });
  });


});
