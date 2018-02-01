import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employee extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    this.checkEmployee();
  }

  checkEmployee = () => {
    const { payroll, account, web3 } = this.props;
    var employee = account;
    console.log(employee);
    payroll.employees.call(employee, {
      from: employee,
      gas: 1000000
    }).then((result) => {
      console.log(result);
      this.setState({
        salary: web3.fromWei(result[2].toNumber()),
        lastPaidDay: new Date(result[3].toNumber() * 1000).toString()
      });
    });
  }

  getPaid = () => {
    const {payroll, account, web3 } = this.props;

    payroll.getPaid({
      from: account,
      gas: 1000000
    }).then((result) => {
      if (result.receipt.status == 0) {
        message.error("转账错误");
        return;
      }
      alert('You have been paid');
      this.checkEmployee();
    });
  }

  renderContent() {
    const { salary, lastPaidDay, balance } = this.state;

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
            <Card title="上次支付">{lastPaidDay}</Card>
          </Col>
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

export default Employee
