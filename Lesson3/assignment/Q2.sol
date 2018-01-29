//如果是由owner调用：
    function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, employee.lastPayday);
        
        delete employees[employeeId];
    }
    
//如果是员工调用：
    function changePaymentAddress(address employeeId) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        
        delete employees[msg.sender];
    }
