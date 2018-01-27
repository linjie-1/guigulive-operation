var Payroll = artifacts.require("./Payroll.sol");


//测试addEmployee函数，4个用例
contract('Payroll', function(accounts) {

 //测试添加employee后，employees中数据正确
  it("employees add employee, salary is 2, addrees is accounts[1].", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.employees.call(accounts[1]);
    }).then((employee) => {
      //console.log(employee[1].valueOf());
      assert.equal(employee[1].valueOf(), web3.toWei(2), "addEmployee:salary is wrong");
      return employee;
    }).then((employee) => {
      //console.log(employee[0].valueOf());
      //console.log(accounts[1]);
      assert.equal(employee[0].valueOf(), accounts[1], "addEmployee:addrees is wrong");
    });
  });

});

contract('Payroll', function(accounts) {
 
  //测试添加employee后，totalSalary数据正确
  it("employees's totalSalary should is employee' salary, so calculateRunway is 10/2.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addFund({value: web3.toWei(10)});
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.calculateRunway.call();
    }).then((result) => {
      //console.log(result);
      assert.equal(result, 10/2, "totalSalary is wrong");
    });
  });  

});

contract('Payroll', function(accounts) {
 
  //测试添加employee后，阻止再添加相同的地址
  it("can't add the same address twice", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('invalid opcode'), "add the same address");
    });
  });  
 
});

contract('Payroll', function(accounts) {
 
  //非雇主添加雇员
  it("not owner can't add the employee", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2, {from: accounts[1]});
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('revert'), "not owner add the employee");
    });
  });  
 
});

//测试removeEmployee函数，4个用例
contract('Payroll', function(accounts) {

  //移除雇员后employees数据正确
  it("remove a employee, salary is 0, addrees is accounts[1].", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.removeEmployee(accounts[1]);
    }).then(() => {
      return PayrollInstance.employees.call(accounts[1]);
    }).then((employee) => {
      //console.log(employee[1].valueOf());
      assert.equal(employee[1].valueOf(), 0, "removeEmployee:salary is not 0");
      return employee;
    }).then((employee) => {
      //console.log(employee[0].valueOf());
      assert.equal(employee[0].valueOf(), 0x0, "removeEmployee:address is not 0x0");
    });
  });  
 
});

contract('Payroll', function(accounts) {

  //移除雇员后totalSalary数据正确
  it("remove a employee, totalSalary is 0.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.removeEmployee(accounts[1]);
    }).then(() => {
      return PayrollInstance.calculateRunway.call();
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('invalid opcode'), "totalSalary is not 0");
    });
  });  
 
});

contract('Payroll', function(accounts) {

  //非雇主移除雇员
  it("not owner can't remove a employee.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.removeEmployee(accounts[1], {from: accounts[2]});
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('revert'), "not owner remove a employee");
    });
  });  
 
});

contract('Payroll', function(accounts) {

  //移除不存在的雇员
  it("can't remove a not exist employee.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      return PayrollInstance.removeEmployee(accounts[2]);
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('invalid opcode'), "remove a not exist employee");
    });
  });  
 
});

//测试getPaid函数，3个用例
contract('Payroll', function(accounts) {
  //付薪水之后账户值大于付薪水之前
  it("the balance after paid bigger than before paid.", () => {
    var beforePaid;
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addFund({value: web3.toWei(10)});
    }).then(() => {
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
      beforePaid = web3.eth.getBalance(accounts[1]);
    }).then(() => {
      for(var timer = Date.now(); Date.now() - timer <= 10500;);
    }).then(() => {
      return PayrollInstance.getPaid({from:accounts[1]});
    }).then(() => {
      return web3.eth.getBalance(accounts[1]);
    }).then((result) => {
      //console.log(beforePaid);
      //console.log(result);
      assert.equal(result > beforePaid, true, "balance not bigger than beforePaid");
    });
  });  
  
});

contract('Payroll', function(accounts) {
  //非雇员调用
  it("not exist employee getPaid.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 2);
    }).then(() => {
       return PayrollInstance.getPaid({from:accounts[2]});
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('invalid opcode'), "not exist employee getPaid");
    });
  });  
  
});

contract('Payroll', function(accounts) {
  //薪水不够
  it("the balance is not enough.", () => {
    return Payroll.deployed().then((instance) => {
      PayrollInstance = instance;
      return PayrollInstance.addEmployee(accounts[1], 1000);
    }).then(() => {
      return PayrollInstance.getPaid({from:accounts[1]});
    }).catch(function(error) {
      //console.log(error.toString());
      assert(error.toString().includes('invalid opcode'), "the balance is not enough.");
    });
  });   
  
});