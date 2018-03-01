import React, { Component } from 'react'
import { Card, Col, Row } from 'antd'

class Common extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  componentDidMount() {
    const { payroll, web3 } = this.props;
    const updateInfo = (error, result) => {
      if (!error) {
        this.checkInfo();
      }
    }

    this.newFund = payroll.NewFund(updateInfo);
    this.getPaid = payroll.GetPaid(updateInfo);
    this.newEmployee = payroll.NewEmployee(updateInfo);
    this.updateEmployee = payroll.UpdateEmployee(updateInfo);
    this.removeEmployee = payroll.RemoveEmployee(updateInfo);

    this.checkInfo();
  }

  componentWillUnmount() {
    this.newFund.stopWatching();
    this.getPaid.stopWatching();
    this.newEmployee.stopWatching();
    this.updateEmployee.stopWatching();
    this.removeEmployee.stopWatching();
  }

  checkInfo = () => {
    const { payroll, account, web3 } = this.props;
    payroll.getInfo.call({
      from: account,
    }).then((result) => {
      this.setState({
        balance: web3.fromWei(result[0].toNumber()),
        runway: result[1].toNumber(),
        employeeCount: result[2].toNumber()
      })
    });
  }

  render() {
    const { runway, balance, employeeCount } = this.state;
    return (
      <div>
        <h2>Common Information</h2>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="Balance">{balance} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="Employee count">{employeeCount}</Card>
          </Col>
          <Col span={8}>
            <Card title="Runway">{runway}</Card>
          </Col>
        </Row>
      </div>
    );
  }
}

export default Common