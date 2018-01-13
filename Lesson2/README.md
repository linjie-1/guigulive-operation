## 硅谷live以太坊智能合约频道官方地址

### 第二课《智能合约设计进阶-多员工薪酬系统》

目录结构
  <br/>|
  <br/>|--orgin 课程初始代码
  <br/>|
  <br/>|--assignment 课程作业提交代码
<br/> 
### 本节知识点
第2课：智能合约设计进阶-多员工薪酬系统
- 动态静态数组的不同
- 函数输入参数检查 revert
- 循环与遍历的安全性
- 程序运行错误检查和容错：assert与require



1第一节课的作业讲解
* 1可调整地址的写法 把frank不写死 写成可传入的参数
* 2钱数也不写死 写成一个可调整的
* 代码 function updateEmployee(address e,uint s){
*     employee = e;
*     salary = s;
*     lastPayday = now;
* }
要注意两个问题 
1 相对于雇主作弊的方法 雇主猥琐 在每个月的最后一天的时候把frank换成了小李
然后在调用getPaid的时候 employee已经不是frank了 造成无法得到薪酬 
通过程序代码来防止这种情况的发生 于是再updateEmployee里添加 一个这个当前雇员的已经工作了多少时间 然后再把当前的员工赋给一个新地址
2这个防止员工作弊因为所有员工都是可以调用 防止员工篡改合约里面的钱  解决方法：在构造函数里面把owner赋值 msg.sender 然后在updateEmployee里面进行判断
if(msg.sender != owner){
    revert();
}

solidity里面除发是要进行整除的 所以需要先算乘法再去做除法
构造函数是为了初始化而用的
只是语言上的区别 
assert(bool) 判断程序运行时确认是否有问题
require(bool) 判断程序输入的时候是否有问题

防止薪酬的单位是 wei  最小的单位
所以要 salary = s* 1 ether;

目标支持多人的员工系统

所以抛出一个新的概念 数组
数组 固定长度数组 uint [5] a
可变长度的数组 动态长度 uint[] a
数组中有的成员
 length
push（只存在于动态数组中）

a[0] 是数组的第一个元素

函数是可以返回多个数值的结果的

动态数组如果一开始没那么长度 是不可以赋值的 要不会报错 
应该先push到动态数组中 再去赋值

设计 过个数组存储多个员工的信息
 address[] employee
unit []  salary
uint[] lastPayday
通过struct 来定义一个对象里面的包含多个属性

结合 struct这个结构体可以设计 通过数组来存储多个员工的信息
Employee[] employees
function addEmployee
function removeEmployee
 
struct Employee{
    address id;
    uint salary;
    uint lastPayday;
}
function addEmployee(address employee,uint salary);
1问题 不会对已经存在的Employee去检测
解决方法 遍历数组 如果重复则不往里面添加这个结构体
for （ uint i = 0； i < employees.length; i++）{
    if(employees[i].id == employee){
    revert();
}
}

function removeEmployee(address employee){
}
2问题 在遍历知道需要执行delete去删除的数组里面的值时 被删除后的位置是一个空值 在数组里后面位置的值并没有往前补齐 所以需要做一下数组的优化处理的小技巧
for(uint i = 0 ; i < employees.length; i++){
    if(employees[i].id == employee){
        delete employees[i];
        employees[i] = employees[employees.length -1];
        employees.length -= 1;
        return;
    }
}

对于重复的代码要提取出来
function _partialPaid(Employee employee){
    uint payment = employee.salary *(now -employee.lastPayday) *payDuration;
    employee.id.transfer(payment);
}

function _findEmployee(address employeeId) returns (Employee){
    for(uint i = 0; i < employees.length ; i++){
        if(employee[i].id == employee){
            return employees[i];
        }
    }
}

可视度 public external  类似于java里面的 public private的概念

struct 是自己定义的类型 所以在这个语言当中 不能把自己定义的struct 的可视度设置为public 应该设置为private


数据存储 data location
storage 实在区块链中不会被抹去 是永久区间
memory 是暂时分配的一个临时空间 可以抹去
calldata  暂时分配的空间 可以被抹去
强制规定 
状态变量 ：storage
function 输入参数 ：calldata
function 返回参数： memory
本地变量 ：storage
规则
变量类似于 c++里面的地址
相同存储空间变量赋值
传递reference（EVM上的内存地址）
不同存储空间变量赋值
拷贝 内存中重新开辟内存空间进行赋值 是一个全新的内存地址

只能把memory里面的值赋值给状态变量 而不能本地变量！

回顾
1错误检查
assert
require 输入的结果是否满足
2数组
动态数组 固定数组
3struct 结构体
struct Name{
}
4数据的存储方式
storage
memory
callData
5语法
for循环
delete 删除
6通过对重复代码的抽取  减少代码的重复性
7 代码的可见度


var 是可以指代任意类型的数据
作业
1加入10个员工 每个员工的薪水都是1ETH
(每次加入一个员工后调用calculateRunway这个函数，并记录消耗的gas是多少 Gas变化么！？ 如果有为什么？)
2如何优化calcluateRunway 这个函数来减少gas的消耗
提交： 智能合约代码，gas变化的记录，calculateRunway函数的优化
1月13号晚上10点前！
