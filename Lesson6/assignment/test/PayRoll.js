var PayRoll = artifacts.require("./PayRoll.sol");

contract('PayRoll', function(accounts) {


  it("...should add an employee into payroll.", function() {

    var employeeid="0xb4fcf5bd0c1687d0bc789d719dd9f5de26c91f03";
    var PayRollInstance=null;
    return PayRoll.deployed().then(function(instance) {
      PayRollInstance = instance;

      //PayRollInstance.addFun({from: accounts[0], value:web3.toWei(10)});

      return PayRollInstance.addEmployee(employeeid,1);

    }).then(function() {
      return PayRollInstance.employees.call(employeeid);
    }).then(function(result) {

      console.log("employee is: ",result);
      assert.equal(result[0], employeeid,"The employee was added.");
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception");
    });
  });


  it("...should add-remove-add an employee into payroll.", function() {

    var employeeid="0xb4fcf5bd0c1687d0bc789d719dd9f5de26c91f07";
    var PayRollInstance=null;
    return PayRoll.deployed().then(function(instance) {
      PayRollInstance = instance;

      //PayRollInstance.addFun({from: accounts[0], value:web3.toWei(10)});

      return PayRollInstance.addEmployee(employeeid,1);

    }).then(function() {
      return PayRollInstance.removeEmployee(employeeid);
    }).then(function(employee) {
      return PayRollInstance.addEmployee(employeeid,1);
    }).then(function(employee) {
      assert.equal(true,true, "The employee was added.");
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception!");
    });
  });

  
  it("...should have the correct msg sender.", function() {

    var employeeid="0xb4fcf5bd0c1687d0bc789d719dd9f5de26c91f07";
    var PayRollInstance=null;
    return PayRoll.deployed().then(function(instance) {
      //console.log("get instance:",instance);
      PayRollInstance = instance;
      return PayRollInstance.addEmployee(employeeid,1,{from: accounts[2]});
    }).catch(function(e){

      //console.log(e);
      //assert.equal(e.toString().includes('Exception'), "wrong caller");
      assert.include(e.toString(), "invalid opcode", "contains 'invalid opcode'");
    });
  });

  it("...should report error if the employee was added again.", function() {

    var employeeid="0xb4fcf5bd0c1687d0bc789d719dd9f5de26c91f07";
    var PayRollInstance;
    return PayRoll.deployed().then(function(instance) {
      PayRollInstance = instance;
      return PayRollInstance.addEmployee(employeeid,1);
    }).then(function(instance) {
      return PayRollInstance.addEmployee(employeeid,1);
    }).catch(function(e){

      //console.log(e);
      assert.include(e.toString(), "invalid opcode", "contains 'invalid opcode'");
    });
  });


  it("...should remove an exist employee", function() {

    var employeeid="0xb4fcf5bd0c1887d0bc789d719dd9f5da26c91f09";
    var PayRollInstance=null;
    return PayRoll.deployed().then(function(instance) {
      PayRollInstance = instance;
      PayRollInstance.addEmployee(employeeid,1);


    }).then(function(instance) {
      return PayRollInstance.removeEmployee(employeeid);
    }).then(function() {
      return PayRollInstance.employees.call(employeeid);
    }).then(function(result) {

      console.log("employeeid:",result);
      console.log("employee is: ",employeeid);
      assert.equal(result[0], 0x0,"The employee was removed.");
    
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception");
    });
  });


  it("...employee should get salary", function() {
    //Error: Error: could not unlock signer account 
    //这里要往一个地址上转账，调用getPaid 给这个地址发钱，必须是一个存在的帐号，要知道private key,
    //地址不可臆造
    var employeeid=accounts[1];
    var PayRollInstance=null;
    var prev_salary=0;

    return PayRoll.deployed().then(function(instance) {
      PayRollInstance = instance;
      PayRollInstance.addFund({from: accounts[0], value:web3.toWei(10)});    
      return PayRollInstance.addEmployee(employeeid,1,{from: accounts[0]});

    }).then(function(e) {
      return web3.eth.getBalance(employeeid);

    }).then(function(balance) {
      console.log("employee balance:",balance);    
      prev_salary=web3.fromWei(balance.valueOf());

    }).then(function() {
      //增加11s
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0})

    }).then(function() {
      console.log("start getPaid");
      return PayRollInstance.getPaid({from:employeeid});

    }).then(function(e) {
      return web3.eth.getBalance(employeeid);

    }).then(function(balance) {
      console.log("balance:",balance.valueOf());
      console.log("employee is: ",employeeid);

      var now_salary=web3.fromWei(balance.valueOf());

      console.log("now salary:",now_salary);

      var incres_salary=now_salary-prev_salary;

      assert(0<incres_salary && incres_salary<=1, "The got salary should between 0 and 1");
    
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception");
    });
  });


  



});
