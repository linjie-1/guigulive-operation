# Contract执行流程

1. addFund

调用AddFund。

![addFund](./images/1.addFund.png)

2. addEmployee

调用addEmployee。

![addEmployee](./images/2.1.addEmployee.png)

调用后可以查询到。

![addEmployeeVerification](./images/2.2.verification.png)

3. updateEmployee

调用之前余额为102 ether。

![beforeUpdateEmployee](./images/3.1.beforeUpdate.png)

调用updateEmployee。

![updateEmployee](./images/3.2.updateEmployee.png)

调用之后余额为117 ether。验证了未支付的费用在调用updateEmployee时会进行支付。

![partialPaidAfterUpdateEmployee](./images/3.3.partialPaid.png)

调用之后，可以查询到更新后的salary。

![salaryUpdated](./images/3.4.updated.png)

4. getPaid

调用之前余额为119 ether。

![beforeGetPaid](./images/4.1.beforeGetPaid.png)

调用getPaid。

![getPaid](./images/4.2.getPaid.png)

调用之后余额为121 ether。

![afterGetPaid](./images/4.3.afterGetPaid.png)

5. changePaymentAddress

调用changePaymentAddress。

![changePaymentAddress](./images/5.1.changePaymentAddress.png)

调用之后，旧地址不存在。

![oldAddressNotExist](./images/5.2.oldAddressNotExist.png)

调用之后，可以查询到新地址。

![newAddressExists](./images/5.3.newAddressExists.png)

6. removeEmployee

调用removeEmployee。

![removeEmployee](./images/6.1.removeEmployee.png)

调用之后，employee不存在。

![employeeNotExist](./images/6.2.employeeNotExist.png)

7. calculateRunway

调用calculateRunway。

![calculateRunway](./images/7.calculateRunway.png)

