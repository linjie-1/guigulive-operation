## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

## Gas usages stats: 
employee# 	trans gas	exec gas 
## original version:

1	22966	1694

2	23747	2475

3	24528	3256

4	25309	4037

5	26090	4818

6	26871	5599

7	27652	6380

8	28433	7161

9	29214	7942

10	29995	8723

		
## optimized version:

1	22353	1081

2	22353	1081

3	22353	1081

4	22353	1081

5	22353	1081

6	22353	1081

7	22353	1081

8	22353	1081

9	22353	1081

10	22353	1081

原本的方法, Gas使用量會跟著employee數目的增加而增加
原因是因為, 每次運算 calcaulateRunway的時候, 我們都是重新計算總薪水的量質, 因此for-loop 隨著員工數目的增加, 而需要iterate更多的員工 導致Gas得使用量也一起增長

- 如何优化calculateRunway这个函数来减少gas的消耗？


我使用了類似於 dynamic programming 的理念, 隨著我們加入新的employee, 更新employee salary, 移除employee, 我們設置一個cache variable存取當下的total_salary, 每家一個新的員工就把當下員工的salary加到  total_saraly裡面, 然後更新的時候隨著更新total_salary, 移除的時候再從total_salary中移除該員工的薪水, 

這樣一來calcaulteRunway 只需要回傳 total_salary的質即可


提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

