/*作业请提交在这个目录下*/
//新增更改员工薪水的支付地址的函数
function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
  var employee = employees[employeeId];
  
  _partialPaid(employee);
  employees[employeeId].id = newEmployeeId;
  employees[newEmployeeId].lastPayday = now;
}

//加分题
L[O] = 0

L[A] = A + merge[L[0],0] 
     = [A,0]

L[B] = B + merge[L[0],0] 
     = [B,0]

L[C] = C + merge[L[0],0] 
     = [C,0]

L[K1] = K1 + merge[[A,0],[B,0],[A,B]]
      = [K1,B] + merge[[A,0],[0],[A]]
      = [K1,B,A,0]
      
L[K2] = K2 + merge[[A,0]],[C,0]],[A,C]]
      = [K2,C,A,0]

L[Z] = Z + merge[[K1,B,A,0],[K2,C,A,0],[K1,K2]]     
     = [Z,K2] + merge[[K1,B,A,0],[C,A,0],K1]
     = [Z,K2,K1] + merge[[B,A,0],[C,A,0]]
     = [Z,K2,K1,A,C,B,0]