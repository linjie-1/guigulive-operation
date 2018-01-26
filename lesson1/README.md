## 硅谷live以太坊智能合约频道官方地址

### 第一课《智能合约设计初阶-单员工薪酬系统》

目录结构
  <br/>|
  <br/>|--orgin 课程初始代码
  <br/>|
  <br/>|--assignment 课程作业提交代码
<br/> 
### 本节知识点
第1课：智能合约设计初阶-单员工薪酬系统
- 合约的基本概念和定义
- Solidity类型系统与传统语言的异同
- Solidity独特的单位系统
- 区块链系统全局变量：区块信息，消息

constant 1对于函数是没有用的  只是一个建议 只是一个视觉上的警告 
               2对于修饰一个变量的话是有作用的 是作为常变量不可更改的

gas 是一个给提供网络的人的类似一个钱的机制  gas是一个函数调用所消耗的gas成本 维持到相对稳定的价格

solidty 的基础语法 可以说很c语言的基础语法是完全一致

但是 是没有float数的 
地址address
balance transfer send call callcode delegatecall

设计
1薪水将全部基于以太币 
  unit salary
  address frank
2每30天发放一次
  unit payDuration
  unit lastPayday

ether 单位
wei 等于 integer 1

block 块

消息
msg.data
msg.gas(uint)
msg.sig
msg.value(uint)

被动调用的编程模式

payable 

如果不用this 去调自己的函数是会较低gas成本的

revert（） 会把没有消耗的gas return回去  如果用throw则会直接消耗gas

重复的变量算两次是 会消耗真金白银
所以要通过本地变量来代替

在solidty 编程语言里面  局部变量的作用域并不是只在自己的花括号里 
