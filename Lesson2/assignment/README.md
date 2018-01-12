## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

* **每次加入员工后的calculateRunway 的Gas消耗记录如下**
* **Gas消耗的变化程大约800 Gas的递增趋势 transaction cost也是1000 gas的递增趋势**
* **原因是因为每次`function calculateRunway()`的`for loop`都会把每个employee做一遍calculation**
        
````
Create Contract
 transaction cost 	763114 gas 
 execution cost 	537610 gas 

Add Fund 100eth
 transaction cost 	21918 gas 
 execution cost 	646 gas 

1, 
"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1
 transaction cost 	105206 gas 
 execution cost 	82334 gas
calculateRunway
 transaction cost 	22966 gas 
 execution cost 	1694 gas 

2,
"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db",1
 transaction cost 	91047 gas 
 execution cost 	68175 gas 
calculateRunway
 transaction cost 	23747 gas 
 execution cost 	2475 gas 

3,
"0x583031d1113ad414f02576bd6afabfb302140225",1
 transaction cost 	91888 gas 
 execution cost 	69016 gas 
calculateRunway
 transaction cost 	24528 gas 
 execution cost 	3256 gas 

4,
"0xdd870fa1b7c4700f2bd7f44238821c26f7392148",1
 transaction cost 	92729 gas 
 execution cost 	69857 gas 
calculateRunway
 transaction cost 	25309 gas 
 execution cost 	4037 gas 

5,
"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",1
 transaction cost 	93570 gas 
 execution cost 	70698 gas 
calculateRunway
 transaction cost 	26090 gas 
 execution cost 	4818 gas 

6,
"0x14723a09acff6d2a60dcdf7aa4aff308fddc1601",1
 transaction cost 	94411 gas 
 execution cost 	71539 gas 
calculateRunway
 transaction cost 	26871 gas 
 execution cost 	5599 gas 

7,
"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2d1",1
 transaction cost 	95252 gas 
 execution cost 	72380 gas 
calculateRunway
 transaction cost 	27652 gas 
 execution cost 	6380 gas 

8,
"0x583031d1113ad414f02576bd6afabfb302140221",1
 transaction cost 	96093 gas 
 execution cost 	73221 gas 
calculateRunway
 transaction cost 	28433 gas 
 execution cost 	7161 gas 

9,
"0xdd870fa1b7c4700f2bd7f44238821c26f7392141",1
 transaction cost 	96934 gas 
 execution cost 	74062 gas 
calculateRunway
 transaction cost 	29214 gas 
 execution cost 	7942 gas 

10,
"0xca35b7d915458ef540ade6068dfe2f44e8fa7331",1
 transaction cost 	97775 gas 
 execution cost 	74903 gas 
calculateRunway
 transaction cost 	29995 gas 
 execution cost 	8723 gas 
````


- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


* **建立一个新的`totalSalary`的`uint`**
* **每次加入，更改或删除员工后更改totalSalary的值**
* **然后每次calculateRunway只需要从Storage中读取totalSalary的值就可以了，避免了每次的loop运算**
* **新的gas变化的记录如下**

````

Create Contract
 transaction cost 	770540 gas 
 execution cost 	544216 gas 

Add Fund 100eth
 transaction cost 	21918 gas 
 execution cost 	646 gas 

1, 
"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1
 transaction cost 	125452 gas 
 execution cost 	102580 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

2,
"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db",1
 transaction cost 	97134 gas 
 execution cost 	74262 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

3,
"0x583031d1113ad414f02576bd6afabfb302140225",1
 transaction cost 	97975 gas 
 execution cost 	75103 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

4,
"0xdd870fa1b7c4700f2bd7f44238821c26f7392148",1
 transaction cost 	98816 gas 
 execution cost 	75944 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

5,
"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",1
 transaction cost 	99657 gas 
 execution cost 	76785 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

6,
"0x14723a09acff6d2a60dcdf7aa4aff308fddc1601",1
 transaction cost 	100498 gas 
 execution cost 	77626 gas 
calculateRunway
 transaction cost 	26871 gas 
 execution cost 	5599 gas 

7,
"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2d1",1
 transaction cost 	95252 gas 
 execution cost 	72380 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

8,
"0x583031d1113ad414f02576bd6afabfb302140221",1
 transaction cost 	101339 gas 
 execution cost 	78467 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

9,
"0xdd870fa1b7c4700f2bd7f44238821c26f7392141",1
 transaction cost 	102180 gas 
 execution cost 	79308 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 

10,
"0xca35b7d915458ef540ade6068dfe2f44e8fa7331",1
 transaction cost 	103021 gas 
 execution cost 	80149 gas 
calculateRunway
 transaction cost 	22124 gas 
 execution cost 	852 gas 
````
