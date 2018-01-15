/*作业请提交在这个目录下*/
Q1: 截图放置在了images文件夹中(./images/*.png)。
Q2: 
如果是由owner调用：
    function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, employee.lastPayday);
        
        delete employees[employeeId];
    }
    
如果是员工调用：
    function changePaymentAddress(address employeeId) onlyOwner employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        
        delete employees[msg.sender];
    }

Q3:
L(O)  := [O]
L(A)  := [A, O]
L(B)  := [B, O]
L(C)  := [C, O]
L(K1)  := [K1, A, B, O]
L(K2)  := [K2, A, C, O]
L(Z)  := [Z, K1, K2, A, B, C, O]
