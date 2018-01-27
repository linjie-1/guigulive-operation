const Payroll = artifacts.require("./Payroll.sol");

const emptyAddress = '0x0000000000000000000000000000000000000000';
const employeeAddress = web3.eth.accounts[1];
//web3.personal.unlockAccount(employeeAddress, "password", 15000);

contract('Payroll', accounts => {

  it("...should add employee ...", () => Payroll.deployed()
    .then(x => {
      x.addEmployee(employeeAddress, 2);
      return x.employees.call(employeeAddress);
    })
    .then(x => assert.equal(x[1].c[0], 20000))
  );

  it("...should not add employee ...", () => Payroll.deployed()
    .then(x => x.addEmployee(employeeAddress, 2))
    .catch(x => assert.isTrue(x instanceof Error))
  );

  it("...should add fund ...", () => Payroll.deployed()
    .then(x =>
      x.addFund({ value: web3.toWei(10, "ether") })
        .then(y => web3.eth.getBalance(x.address))
    )
    .then(x => assert.equal(web3.fromWei(x.valueOf()), 10))
  );

  it("...should getPaid ...", done => 
    setTimeout(() => Payroll.deployed()
      .then(x => x.getPaid({ from: employeeAddress })
        .then(y => web3.eth.getBalance(x.address))
      )
      .then(x => assert.equal(web3.fromWei(x.valueOf()), 8))
      .then(x => done()),
      12000
    )
  );

  it("...should remove employee ...", () => Payroll.deployed()
    .then(x => {
      x.removeEmployee(employeeAddress);
      return x.employees.call(employeeAddress);
    })
    .then(x => assert.equal(x[0], emptyAddress))
  );

  it("...should not remove employee ...", () => Payroll.deployed()
    .then(x => x.addEmployee(employeeAddress))
    .catch(x => assert.isTrue(x instanceof Error))
  );

});
