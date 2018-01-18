作业
1. 添加10个地址，每添加一个，执行一次calculateRunway,观察消耗的gas变化

从第一个地址到第十个地址，执行EVM所消耗的gas如下：

1------1694gas
2------2475gas
3------3256gas
4------4037gas
5------4818gas
6------5599gas
7------6380gas
8------7161gas
9------7942gas
10-----8723gas

2. 为什么消耗的gas有变化？

因为在for循环中，随着地址的增多，需要越来越多次的从 storage 读取数据

3. 对calculateRunway函数进行优化

最简单的是增加一个全局状态存储所有的工资之和，但需要在多个函数内进行修改，不利于开发维护。

还有一种思路是保持for循环结构不变，将 employees 的length存为local变量，避免每次都从storage上去读取，代码如下：

    function calculateRunway_localLength() returns (uint){
        uint totalSalary = 0;
        uint _length = employees.length;
        for(uint i=0;i<_length; i++){
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

我的优化方法是新增一个计算工资之和的函数，该函数通过递归得到工资之和，gas消耗有一定减少,具体代码如下:

    function getAllSalary(uint i) private returns (uint){
            return employees[i].salary + ( i>0 ? getAllSalary(i-1) : 0);
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        return this.balance / getAllSalary(employees.length-1);
    }


下面比较一下 1)原始方法 2)存length方法 3)递归获取所有工资方法 这三个方法的gas消耗

| 账户数 | 原始方法 | length方法 | 递归方法 |
| ------ | ------  | ------  | ------  |
| 1 | 1694 | 1499 | 1465 |  
| 2 | 2475 | 2072 | 2047 |
| 3 | 3256 | 2645 | 2629 |
| 4 | 4037 | 3218 | 3211 |
| 5 | 4818 | 3791 | 3793 |
| 6 | 5599 | 4364 | 4375 |
| 7 | 6380 | 4937 | 4957 |
| 8 | 7161 | 5501 | 5539 |
| 9 | 7942 | 6083 | 6121 |
| 10 | 8723 | 6656 | 6703 |

注意：函数名影响gas，所以必须保持一致，测试一个函数时，注释掉其他函数。

结论：总体length方法和递归方法差不多，但账户数小的时候length方法消耗gas多，账户数大的时候递归方法消耗gas多，两者表现有差异，原因需要后续进一步分析EVM的指令。

