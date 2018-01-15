//新增更改员工薪水的支付地址的函数
function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
  var employee = employees[employeeId];
  
  _partialPaid(employee);
  employees[employeeId].id = newEmployeeId;
  employees[newEmployeeId].lastPayday = now;
}

//加分题
O[O],
A[A,O],
B[B,O],
C[C,O],
K1[K1,A,B,O],
K2[K2,A,C,O],
Z[K1,K2,A,B,C,O]