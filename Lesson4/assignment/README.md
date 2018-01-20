## 硅谷live以太坊智能合约 第四课作业
这里是同学提交作业的目录

### 第四课：课后作业
- 将第三课完成的payroll.sol程序导入truffle工程
- 在test文件夹中，写出对如下两个函数的单元测试：
- function addEmployee(address employeeId, uint salary) onlyOwner
- function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
- 思考一下我们如何能覆盖所有的测试路径，包括函数异常的捕捉
- (加分题,选作）
- 写出对以下函数的基于solidity或javascript的单元测试 function getPaid() employeeExist(msg.sender)
- Hint：思考如何对timestamp进行修改，是否需要对所测试的合约进行修改来达到测试的目的？


### 作业提交：
1. 测试源文件：payroll.js, test运行结果截屏：truffle_test_snapshot.jpg

包含六个测试函数：

- 1.0 add a new employee

- 1.1 should not add a new employee by non-owner person
  
- 1.2 should not add an existed employee
  
- 2.0 remove employee with expected behavior: add employee first and then remove
  
- 2.1 remove employee by non-owner person
  
- 2.2 remove non-existed employee

2. 为了覆盖所有测试路径，我们需要考虑每一种操作的可能，譬如非owner用户添加或者删除employee，添加已有的employee，删除不存在的employee等各种情况，并用相应的函数测试。同时，操作完成后，需要检查结果是否符合预期，譬如，添加以后的employee需要检查id和salary是否与输入的值相同。
