var Payroll = artifacts.require("Payroll");
var testSalary = 10;

contract('Payroll', function([owner, employee, employee1]) {
    let payrollInstance;

    beforeEach('setup contract for each test', async function() {
        payrollInstance = await Payroll.new(owner);
    })

    it("addEmployee should be rejected since it's not from owner", async function() {
        try {
            let res = await payrollInstance.addEmployee(employee, testSalary, {from: employee});
        } catch(error) {
            assert(error.toString().includes("VM Exception while processing transaction: revert"), error.toString());
        }
    })

    it("addEmployee should accept addEmployee", async function() {
        await payrollInstance.addEmployee(employee, testSalary, {from: owner});
        let res = await payrollInstance.checkEmployee(employee);
        assert(res.toString(10).includes("10000000000000000000"), "salary doesn't match");
    })

    it("removeEmployee should be rejected since it's not from owner", async function() {
        await payrollInstance.addEmployee(employee, testSalary, {from: owner});
        try {
            let res = await payrollInstance.removeEmployee(employee, {from: employee1});
        } catch (error) {
            assert(error.toString().includes("VM Exception while processing transaction: revert"), error.toString());
        }
    })

    it("removeEmployee should be return invalid opcode since there's not such employee", async function() {
        try {
            let res = await payrollInstance.removeEmployee(employee, {from: owner});
        } catch (error) {
            assert(error.toString().includes("VM Exception while processing transaction: invalid opcode"), error.toString());
        }
    })

    it("removeEmployee should succeed", async function() {
        await payrollInstance.addEmployee(employee, testSalary, {from: owner});
        await payrollInstance.removeEmployee(employee)
    })
})
