
问题1:下面注释掉的部分留下的话，就出不了通用信息界面，很苦恼，感觉是地址有问题，找了半天也不知道改哪里，求救！！！
1、Employer.js里的   
 renderContent = () => {
    const { account, payroll, web3 } = this.props;
    const { mode, owner } = this.state;
/*************** 
    if (owner !== account) {
      return <Alert message="你没有权限" type="error" showIcon />;
    }
********************/
    switch(mode) {
      case 'fund':
        return <Fund account={account} payroll={payroll} web3={web3} />
      case 'employees':
        return <EmployeeList account={account} payroll={payroll} web3={web3} />
    }
 }

2、Employee.js里的 
	  renderContent(){
       const { salary, lastPaidDate, balance } = this.state;
       /********* 
            if (!salary || salary === '0') {
              return   <Alert message="你不是员工" type="error" showIcon />;
            }
   *************/
        return (
          <div>
            <Row gutter={16}>
              <Col span={8}>
                <Card title="薪水">{salary} Ether</Card>
              </Col>
              <Col span={8}>
                <Card title="上次支付">{lastPaidDate}</Card>
              </Col>
              <Col span={8}>
                <Card title="帐号金额">{balance} Ether</Card>
              </Col>
            </Row>
    
            <Button type="primary" icon="bank" onClick={this.getPaid}>
              获得酬劳
            </Button>
          </div>            
        );
    }


问题2:
增加资金按钮无效，console里报错，又是地址，求救！！！
 Unhandled Promise Rejection: Error: invalid address

问题3:
还不能跟metamask交流，感觉这段代码好没尊严。
