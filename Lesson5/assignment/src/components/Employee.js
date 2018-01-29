import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employer extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    console.log('Employer componentDidMount');

    this.checkEmployee();
  }
  // function checkInfo() returns (uint balance, uint runway, uint employeeCount) {

  checkEmployee = () => {
     const {payroll , account , web3} = this.prop;
     console.log('account balance:'+account.balance);

     payroll.checkInfo.call({
       from : account
     }).then((result) => {
       console.log('result[0]:'+result[0].toNumber() +',result[1]'+result[1].toNumber()+',result[2]'+result[2].toNumber())
       this.setState({
        balance : web3.fromWei(result[0].toNumber()),
        runway : result[1].toNumber(),
        employeeCount : result[2].toNumber()
       });
     })
  }

  getPaid = () => {
    const {payroll , account} = this.prop;
    payroll.getPaid({
      from : account
    }).then((result) =>{
      message.info("have paid!");
    })
  }

  renderContent() {
    const { salary, lastPaidDate, balance } = this.state;

    if (!salary || salary === '0') {
      return   <Alert message="你不是员工" type="error" showIcon />;
    }

    return (
      <div>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="薪水">{salary} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="上次支付">{lastPaidDate}</Card>
          </Col>componentDidMount
          <Col span={8}>
            <Card title="帐号金额">{balance} Ether</Card>
          </Col>
        </Row>

        <Button
          type="primary"
          icon="bank"
          onClick={this.getPaid}
        >
          获得酬劳
        </Button>
      </div>
    );
  }

  render() {
    const { account, payroll, web3 } = this.props;

    return (
      <Layout style={{ padding: '0 24px', background: '#fff' }}>
        <Common account={account} payroll={payroll} web3={web3} />
        <h2>个人信息</h2>
        {this.renderContent()}
      </Layout >
    );
  }
}

export default Employer
