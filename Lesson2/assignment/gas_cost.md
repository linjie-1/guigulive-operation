### calculateRunway cost

- employee 1
  + transaction cost    22966 gas
  + execution cost     1694 gas
- employee 2
  + transaction cost     23747 gas
  + execution cost     2475 gas
- employee 3
  + transaction cost    24528 gas
  + execution cost     3256 gas
- employee 4
  + transaction cost    25309 gas
  + execution cost     4037 gas
- employee 5
  + transaction cost    25309 gas
  + execution cost     4037 gas
- employee 6
  + transaction cost    26090 gas
  + execution cost     4818 gas
- employee 7
  + transaction cost    26871 gas
  + execution cost     5599 gas
- employee 8
  + transaction cost    27652 gas
  + execution cost     6380 gas
- employee 9
  + transaction cost    28433 gas
  + execution cost     7161 gas
- employee 10
  + transaction cost    29214 gas
  + execution cost     7942 gas

### why

calculateRunway每次都循环一次employees array来计算totalSalay, employee的人数越多消耗的gas越多。

### 优化

每次加入或者删除employee的时候直接更新totalSalary，就免去了calculaterunway中的遍历。
