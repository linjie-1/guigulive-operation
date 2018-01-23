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
      return PayRollInstance.employeeList.call(employeeid);
    }).then(function(result) {

      console.log("employee is: ",result);
      assert.equal(result[0], employeeid,"The employee was added.");
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception");
    });
  });


  it("...should add an employee into payroll.", function() {

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
      return PayRollInstance.employeeList.call(employeeid);
    }).then(function(result) {

      console.log("employeeid:",result);
      console.log("employee is: ",employeeid);
      assert.equal(result[0], 0x0,"The employee was removed.");
    
    }).catch(function(e){
      console.log(e);
      assert.equal(false,true,"should NOT throw exception");
    });
  });

  



});
