// - 在test文件夹中，写出对如下两个函数的单元测试：
// - function addEmployee(address employeeId, uint salary) onlyOwner
// - function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)

var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Add employee now", function() {
    return Payroll.deployed().then(function(instance) {

      payrollInstance = instance;
      console.log('Adding employee...');
      payrollInstance.addEmployee(accounts[1], 1);
      return payrollInstance.getEmployeeSalary(accounts[1]);

    }).then((salary) => {
      
      assert.equal(salary.valueOf(), web3.toWei(1, 'ether'), 'Failed');

    })
  });

  it("Add fund now", function() {
    var constractAddress;
    return Payroll.deployed().then(function(instance) {

      constractAddress = instance.address;
      return instance.addFund({value:web3.toWei(10, 'ether')});

    }).then((result) => {

      balance = web3.eth.getBalance(constractAddress);
      console.log(balance);
      assert.equal(balance.valueOf(), web3.toWei(10, 'ether'), 'Failed');
    
    })
  })

  it("Get paid now", function() {
    var old_balance = 0;
    return Payroll.deployed().then(function(instance) {

      constractAddress = instance.address;
      old_balance = web3.eth.getBalance(constractAddress).valueOf();
      console.log(old_balance);
      
      return instance.getPaid({from: accounts[1]});

    }).then(function() {
      
      var new_balance = web3.eth.getBalance(constractAddress).valueOf();
      console.log(new_balance);
      var for_salary = web3.fromWei(old_balance - new_balance, 'ether');
      console.log(for_salary);
      assert.equal(1,for_salary,"Failed");

    })
  })

  it("Remove employee", function() {
    return Payroll.deployed().then(function(instance) {
      
      payrollInstance.removeEmployee(accounts[1]);
      return payrollInstance.getEmployeeSalary(accounts[1]);

    }).then((salary) => {

      assert.equal(salary.valueOf(), 0, "Failed");

    })
  });

});
