var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', accounts => {

  it("...should add employ ...", () => Payroll.deployed()
    .then(x => {
      x.addEmployee('0xc479f20b44276e99d949531a0bc0100b979563c6', 2);
      return x.employees.call('0xc479f20b44276e99d949531a0bc0100b979563c6');
    })
    .then(x => assert.equal(x[1].c[0], 20000))
  );

  it("...should not add employ ...", () => Payroll.deployed()
    .then(x => x.addEmployee('0xc479f20b44276e99d949531a0bc0100b979563c6', 2))
    .catch(x => assert.isTrue(x instanceof Error))
  );

  it("...should remove employ ...", () => Payroll.deployed()
    .then(x => {
      x.removeEmployee('0xc479f20b44276e99d949531a0bc0100b979563c6');
      return x.employees.call('0xc479f20b44276e99d949531a0bc0100b979563c6');
    })
    .then(x => assert.equal(x[0], '0x0000000000000000000000000000000000000000'))
  );

  it("...should not remove employ ...", () => Payroll.deployed()
    .then(x => x.addEmployee('0xc479f20b44276e99d949531a0bc0100b979563c6'))
    .catch(x => assert.isTrue(x instanceof Error))
  );

});
