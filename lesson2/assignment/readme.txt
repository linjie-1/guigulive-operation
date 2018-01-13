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

我的优化方法是新增一个计算工资之和的函数，该函数通过递归得到工资之和，gas消耗有一定减少,具体代码如下:

    function getAllSalary(uint i) private returns (uint){
            return employees[i].salary + ( i>0 ? getAllSalary(i-1) : 0);
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        return this.balance / getAllSalary(employees.length-1);
    }

