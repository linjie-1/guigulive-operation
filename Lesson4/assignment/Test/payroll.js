+// import expectThrow from '../src/expectThrow.js';
 +
 +var Ownable = artifacts.require("./Ownable.sol");
 +var SafeMath = artifacts.require("./SafeMath.sol");
 +var Payroll = artifacts.require("./Payroll.sol");
 +var caseCounter = 0;
 +
 +contract('Payroll', function(accounts) {
 +
 +    it("...is able to add employees", function() {
 +        return Payroll.deployed().then(instance => {
 +            payrollcontract = instance;
 +            caseCounter++;
 +            return payrollcontract.addEmployee(web3.eth.accounts[caseCounter], 1);
 +        }).then(()=>{
 +            return payrollcontract.checkEmployeeExists.call(web3.eth.accounts[caseCounter])           
 +        }).then(result => {
 +            assert.equal(result, true, "employee "+caseCounter+" added. should exist");
 +        });
 +    });
 +
 +    it("...cannot add employees if by a non-owner", function() {
 +        return Payroll.deployed().then( async (instance) => {
 +
 +            payrollcontract = instance;
 +            caseCounter++;
 +            await expectThrow(payrollcontract.addEmployee(web3.eth.accounts[caseCounter], 1, {from: web3.eth.accounts[1]}));
 +
 +        })
 +
 +    });
 +
 +    it("...is able to remove employees", function() {
 +        return Payroll.deployed().then(instance => {
 +            payrollcontract = instance;
 +            caseCounter++;
 +            return payrollcontract.addEmployee(web3.eth.accounts[caseCounter], 1);
 +        }).then(()=>{
 +
 +            return payrollcontract.removeEmployee(web3.eth.accounts[caseCounter]);
 +
 +        }).then(() => {
 +            return payrollcontract.checkEmployeeExists.call(web3.eth.accounts[caseCounter])           
 +        }).then(result => {
 +            assert.equal(result, false, "employees[ "+caseCounter+" ] removed. should not exist");
 +        });
 +    });
 +
 +    it("...cannot remove employees if by non-owner", function() {
 +        return Payroll.deployed().then(instance => {
 +            payrollcontract = instance;
 +            caseCounter++;
 +            return payrollcontract.addEmployee(web3.eth.accounts[caseCounter], 1);
 +        }).then(async ()=>{
 +
 +            await expectThrow(payrollcontract.removeEmployee(web3.eth.accounts[caseCounter], {from: web3.eth.accounts[1]}));
 +
 +        });
 +    });
 +
 +    it("...cannot remove nonexisted employees", function() {
 +        return Payroll.deployed().then(async (instance) => {
 +            payrollcontract = instance;
 +            caseCounter++;
 +            await expectThrow(payrollcontract.removeEmployee(web3.eth.accounts[caseCounter]));
 +        });
 +    });
 +
 +
 +});
 +
 +async function expectThrow(promise) {
 +    try {
 +      await promise;
 +    } catch (error) {
 +      // TODO: Check jump destination to destinguish between a throw
 +      //       and an actual invalid jump.
 +      const invalidOpcode = error.message.search('invalid opcode') >= 0;
 +      // TODO: When we contract A calls contract B, and B throws, instead
 +      //       of an 'invalid jump', we get an 'out of gas' error. How do
 +      //       we distinguish this from an actual out of gas event? (The
 +      //       testrpc log actually show an 'invalid jump' event.)
 +      const outOfGas = error.message.search('out of gas') >= 0;
 +      const revert = error.message.search('revert') >= 0;
 +      assert(
 +        invalidOpcode || outOfGas || revert,
 +        'Expected throw, got \'' + error + '\' instead',
 +      );
 +      return;
 +    }
 +    assert.fail('Expected throw not received');
 +  }; 
