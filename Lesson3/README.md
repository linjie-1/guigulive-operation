### 区块链开发第三课


####MAPPING(哈希表)
- 类似于map(c++)
- key(bool,int,address,string) 只有这四种类型可以用
- value（任何类型）
- mapping(address => Empolyee) employees
- 只能做成员变量，不能做本地局部变量

####MAPPING底层实现
- 不使用数组和链表，不需要扩容
- hash函数为kecash256hash,在storage上存储，理论无限大的哈希表
- 无法native的遍历整个mapping（不能统计总数）
- 赋值 employess[key] = value
- 取值 value = employees[key]
- value是引用，在storage上存储，可以直接修改
- 当key不存在，value = type‘s default

