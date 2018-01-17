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

### Solutions:

#### 第一题

- `owner`

    ![owner](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/0.png)

- `addFund`

    ![addFund](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/1.png)

- `addEmployee`: "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 2

    ![addEmployee](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/2.png)

- `addEmployee`: "0xdd870fa1b7c4700f2bd7f44238821c26f7392148", 1

    ![addEmployee](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/3.png)

- `calculateRunway`

    ![calculateRunway](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/4.png)

- `hasEnoughFund`

    ![hasEnoughFund](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/5.png)

- `updateEmployee`: "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1

    ![updateEmployee](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/6.png)

- `changePaymentAddress`: "0x583031d1113ad414f02576bd6afabfb302140225"

    ![changePaymentAddress](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/7.png)

- `getPaid`

    ![getPaid](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/8.png)

- `removeEmployee`: "0xdd870fa1b7c4700f2bd7f44238821c26f7392148"

    ![removeEmployee](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/9.png)

- `transferOwnership`: "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"

    ![transferOwnership](https://github.com/h1994st/guigulive-operation/raw/master/Lesson3/assignment/images/10.png)

#### 第二题

***(见代码)***

#### 第三题

```
L(O)  := [O]

L(A)  := [A] + merge(L(O), [O])
       = [A] + merge([O], [O])
       = [A, O]
L(B)  := [B, O]
L(C)  := [C, O]

L(K1) := [K1] + merge(L(B), L(A), [B, A])
       = [K1] + merge([B, O], [A, O], [B, A])
       = [K1, B, A, O]
L(K2) := [K2] + merge(L(C), L(A), [C, A])
       = [K2] + merge([C, O], [A, O], [C, A])
       = [K2, C, A, O]

L(Z)  := [Z] + merge(L(K2), L(K1), [K2, K1])
       = [Z] + merge([K2, C, A, O], [K1, B, A, O], [K2, K1])
       = [Z, K2, C, K1, B, A, O]
```
