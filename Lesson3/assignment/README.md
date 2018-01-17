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

### 第一题
在img目录下，一共10个函数

### 第二题
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function changePaymentAddress(address employeeId, address employeeIdNew) onlyOwner employeeExist(employeeId) employeeNotExist(employeeIdNew){
        var oldEmployee = employees[employeeId];
        
        employees[employeeIdNew] = oldEmployee;
        delete employees[employeeId];
    }

将id是否存在的判断都变为modifier

### 第三题
L(O) = [O]

L(A) = [A] + merge L(L(O), [O]) 
     = [A] + merge L([0], [0])
     = [A, O]
同理 L(A) = [B,O] = [C,O]


L(K1) = [K1] + merge L(L(A), L(B), [A, B]) 
      = [K1] + merge L([A, O], [B, O], [A, B]) 
      = [K1, A] + merge L([O], [B, O], [B]) 
      = [K1, A, B] + merge L([O], [O], [O])
      = [K1, A, B, O]

L(K2) = [K2] + merge L(L(A), L(C), [A, C]) 
      = [K2] + merge L([A, O], [C, O], [A, C]) 
      = [K2, A] + merge L([O], [C, O], [C]) 
      = [K2, A, C] + merge L([O], [O], [O])
      = [K2, A, C, O]

L(Z) = [Z] + merge L(L(K1), L(K2), [K1, K2]) 
     = [Z] + merge L([K1, A, B, O], [K2, A, C, O], [K1, K2])
     = [Z, K1] + merge L([A, B, O], [K2, A, C, O], [K2]) 
     = [Z, K1, K2] + merge L([A, B, O], [A, C, O]) 
     = [Z, K1, K2, A] + merge L([B, O], [C,O])
     = [Z, K1, K2, A, B] + merge L([O], [C, O])
     = [Z, K1, K2, A, B, C] + merge L([O], [O])
     = [Z, K1, K2, A, B, C, O]