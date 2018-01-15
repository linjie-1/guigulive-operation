## 硅谷live以太坊智能合约频道官方地址

### 第二课《智能合约设计进阶-多员工薪酬系统》

目录结构
  <br/>|
  <br/>|--orgin 课程初始代码
  <br/>|
  <br/>|--assignment 课程作业提交代码: before_optimization.sol and after_optimization.sol
<br/> 
### 本节知识点
第2课：智能合约设计进阶-多员工薪酬系统
- 动态静态数组的不同
- 函数输入参数检查 revert
- 循环与遍历的安全性
- 程序运行错误检查和容错：assert与require


source code:

初始版本：Lesson2/assignment/before_optimization.sol
这个版本的calculateRunway函数用for-loop统计total salary，随着员工数量增加，这部分的计算开销即gas consumption会逐渐增加，具体数字请见readme文档里面的表格。

优化版本： Lesson2/assignment/after_optimization.sol
这个版本用contract的local variable “totalSalary”来保存当前所有employee的工资之和，这样calculateRunway函数调用的gas consumption变成常量。相应的改动是，每次修改employee记录的时候相应更新totalSalary的值。
