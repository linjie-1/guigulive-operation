第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线


## 答案

### 第一题
参考 EnhancedPayroll.sol，截图参考 `screenshots` 文件夹

### 第二题
参考 EnhancedPayroll.sol.

可以把检查是否 newId 已经存在于 employees（不允许存在）抽取为 modifier，也就是正好和 employeeExist 意思相反的一个 modifier

modifier employeeNotExist(address id) {
    var employee = employees[id];
    assert(employee.id == 0x0);
    _;
}

### 第三题
很抱歉最近时间比较紧张，粗略看了一下 C3 Linearization，需要花一些时间理解，暂时无法完成。周末想办法再做加分题吧。
