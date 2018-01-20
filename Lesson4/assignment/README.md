
部署文件位于 ./payroll/migrations/下 _deploy_contracts.js需要部署相应的合约文件

测试文件位于 ./payroll/test/下 分别为TestPayroll.js和TestPayroll.rol 

测试了payroll.sol的两个函数：addEmployee 和 removeEmployee

测试截图位于本文件夹内

基本上使用then().catch()或try{}catch(e){}捕捉异常

<!--## 硅谷live以太坊智能合约 第四课作业
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
-->
