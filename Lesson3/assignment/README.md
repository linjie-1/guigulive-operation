## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2



第三课课程学习笔记
1 作业回顾
随着人数的增多 数组变长 导致 for 循环的时候 gas的消耗会越来越多 这样来看是换不来
 
所以抛出问题 我们应该如何 减少gas的消耗

引出 map的数据类型
类似于java中的 map 或者Python 和iOS object-c dict nsdictionary的概念
key 只能是这几种数据类型 （bool,int,address,string）
value 可以是任意类型
例如 ：mapping(address => Employee) employees 
只能做成员变量，不能做本地的局部变量

mapping 低层实现
不适用数组+链表 ，不需要扩容
hash 函数为keccak256hash ，在storage上存储，理论无限大的hash表
无法natiive的遍历整个mapping    
赋值employee[key] = value
取值 value = employees[key]
value是引用 ，在storage上存储，可以直接修改
当key不存在，value = type ‘default

函数参数返回进阶
命名参数返回
命名返回参数直接赋值

function checkEmployee(address employeeId) returns (uint,uint){// （uint salary,uint lastPayday）即为命名参数返回
    var employee = employees[employeeId];
    return (employee).salary,employee.lastPayday);// salary = employees.salary; lastPayday = employees.lastPayday; 即为命名返回参数直接赋值
}

可视度 与 继承 
public 谁都可见 
external 只有“外部调用”可见
internal 外部调用不可见，内部和子类可见
private 只有当前合约可见
都是可以作用在函数上 成员变量上
分别来说
状态变量上 可以使用  public internal private
状态变量的默认状态是 internal
public 等于自动定义了取值函数
相当于 java里面的get方法 自动设置了这个函数
private 不代表别的合约无法肉眼看到 ，只代表别的区块链智能合约无法看到
重要的事情说三遍 合约的所有成员变量都是肉眼可见的！
 
函数上 public external internal private
默认函数上的可视度是public

external
contract Test{
    uint a;
    function func1() external{}

    function func2() {
        this.func1();//等于把这个自己的合约 当做外部合约去调用使用  要不是不能直接去调用func1函数的
    }
}

继承 —基本语法
类似java里继承的语法
除了private 定义的函数和成员变量 剩下的 修饰的可见度的 词 都是可以在子类中去调用的

也可以静态的去定义父类
contract child2 is Parent(666){
}

继承的抽象合约
抽象合约 即为父类只有这个函数的定义 没有实现 没有定义 而子类继承这个父类 后实现的函数是有实现的 
抽象函数你是没有办法把它定义到区块链当中的！

继承 自 interface 类java的概念
只有function 的定义 剩下的什么都没有
必须把接口 去继承实现的

抽象合约和interface的区别就是 抽象合约仍是个合约  它可以有自己的构造函数 状态变量 struct enum 和function 
而interface  不可继承自其它的合约 或者interface 没有构造函数 没有状态变量 没有stuct 没有enum 只有个function定义啥都没有！！！
告诉我们只有编程人的框架 
作为子类继承某个interface 就要求子类把 interface的函数全部实现  要不就无法部署到以太坊的智能合约里

多继承
A
contract Base1{
    function func1() {}
}
contract Base2{
    function func2(){}
}

contract Final is Base1, Base2{
}

B
contract Base1{
    function func1() {}
}
contract Base2{
    function func1(){}
}

contract Final is Base1, Base2{//继承顺位是从后往前的
}
contract test{
    Final f = new Final();
    f.func1();//是继承顺位的前一位 Base2的function1被调用
}

C
super : 动态绑定上级函数
contract foundation(){
    function func1{}
}

contraction Base1 is foundation{
    function func1(){ super.func1(); }
}

contraction Base2 is foundation{
    function func1(){ super.func1(); }
}

contract Final is Base1 ,Base2{
}

contract test{
    Final f = new Final();
    f.func1();//函数调用次序 Bse2.func1 Base1.func1 foundation.func1
}

modifier  可以把要修饰的功能提取出来 
modifier onlyOwner{
    require(msg.sender == owner);
    -;//上表示-上面是加载函数前面的
}

function addEmployee (address employeeId)  onlyOwner{
} 

modifier someModifier (){
    -;
    a = 1;//这种格式的语义是 除了return之外的语句 然后把 a = 1放在了 return之前执行
}
return 之后的函数都是不执行的

在solidity语言中的加减乘数是非常危险的操作 uint8 是个8位的二级制的数 0-256  比如由于整形溢出导致运算的结果错误 是个非常严重的错误 因为数字就是金钱
 
库函数 可以是 这些算数的方法 避免错误的出现

import “./SafeMath.sol"
contract Test{
using SafeMath for uint8
uint public a = 101;
function set()  public {
    a = a.sub(100);
}
}

Ownable 的引入

import “./Ownable.sol”;
Payroll is Ownable{
}

建议学习一下 zeppelin-solidity 的库里面的各种函数 然后可以理解并运用到自己的项目中

回顾总结

mapping
可视度
功能 继承 modifier
 library 比较流行的库zeppelin

自学 C3 Linearization  求一下 contraact Z的继承线
