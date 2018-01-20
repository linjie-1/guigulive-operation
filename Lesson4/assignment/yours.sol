/*作业请提交在这个目录下*/
/******
题目1:
完成代码见src目录
*/

/******
题目2:
列举不同的输入参数：异常参数和正常参数；
使用不同的调用address：需要学习如何切换address
函数异常用 .catch(function(error) 来捕捉。

基于JS的测试：
步骤1:修改文件夹migrations下的文件2_deploy_contracts.js

var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Payroll);
};

步骤2:在test目录下新建payroll.js文件

var Payroll = artifacts.require("./Payroll.sol");

// 测试删除员工接口
contract("Payroll-removeEmployee", function(accounts) {
     var removeAddress = 0x1238420F4922DB63eA2392194760348ED4Fe4DEF;
     it("...Remove Employee removeAddress success.", function() {
         return Payroll.deployed().then(function(instance) {
             payrollInstance = instance;
             return payrollInstance.addEmployee(removeAddress,1);
        }).then(function() {
             return payrollInstance.removeEmployee(removeAddress);
         }).then(function() {
             return payrollInstance.employeeIsExist.call(removeAddress);
         }).then(function(isExist) {
             assert.equal(isExist, false, "Remove Employee removeAddress success.");
         });
     });
     
});

//测试新增员工接口
contract("Payroll-addEmployee", function(accounts) {
    var newAddress = 0x1238420F4922DB63eA2392194760348ED4Fe4ABC;
        it("...Add Employee newAddress success.", function() {
            return Payroll.deployed().then(function(instance) {
                payrollInstance = instance;
                return payrollInstance.addEmployee(newAddress,1,{from: accounts[0]});
            }).then(function() {
                return payrollInstance.employeeIsExist.call(newAddress);
            }).then(function(isExist) {
                assert.equal(isExist, true, "Add Employee newAddress success.");
            });
    });
});

//测试新增员工异常
contract("Payroll-addEmployee-catchError", function(accounts) {
    var newAddress = 0x1238420F4922DB63eA2392194760348ED4Fe4ABC;
        it("...Add Employee newAddress success.", function() {
            return Payroll.deployed().then(function(instance) {
                payrollInstance = instance;
                return payrollInstance.addEmployee(newAddress,1,{from: accounts[0]});
            }).then(function() {
                return payrollInstance.addEmployee(newAddress,2,{from: accounts[0]});
            }).catch(function(error) {
                console.log(error.toString());
                assert(error.toString().includes('invalid'), "addEmployee");
                
            });
    });
});

//测试删除员工异常
contract("Payroll-removeEmployee-catchError", function(accounts) {
    var removeAddress = 0x1238420F4922DB63eA2392194760348ED4Fe4DEF;
    it("...Remove Employee removeAddress success.", function() {
        return Payroll.deployed().then(function(instance) {
            return payrollInstance.removeEmployee(removeAddress);
        }).catch(function(error) {
            console.log(error.toString());
            assert(error.toString().includes('invalid'), "removeEmployee");
        });
    });
});
*/


/******
题目3:
需要对原来的接口做一定的变化，getPaid（）返回转帐数目，以便和收到数目做对比。
遗留学习点：如何切换用户地址以及获得某地址下的账目数。

步骤1:修改Payroll.sol下的getPaid函数：
function getPaid() employeeExist(msg.sender) returns (uint) {
        var employee = employees[msg.sender];
            
        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);
            
        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
        return employee.salary;
    }

步骤2：在test目录下的payroll.js文件增加：
contract("Payroll-getPaid-MsgSender", function(accounts) {
    it("...getPaid success.", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[0],1);
        }).then(function() {
            setTimeout(function(){
                return payrollInstance.getPaid();
            },11000);   
            }).then(function(getsalary) {
                console.log(getsalary);
                assert.equal(getsalary > 0, true, "getPaid success.");
              });
    });
});

contract("Payroll-getPaid-notMsgSender", function(accounts) {
    it("...getPaid success.", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1],1);
        }).then(function() {
            setTimeout(function(){
                return payrollInstance.getPaid();
            },11000);   
            }).then(function(getsalary) {
                assert.equal(getsalary > 0, true, "getPaid success.");
              });
    });
});
*／

