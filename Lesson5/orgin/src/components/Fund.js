import React, { Component } from 'react'
import { Form, InputNumber, Button } from 'antd';

import Common from './Common';

const FormItem = Form.Item;

class Fund extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  handleSubmit = (ev) => {
    ev.preventDefault();
    const { payroll, account, web3 } = this.props;
    payroll.addFund({
      from: account,
      value: web3.toWei(this.state.fund)
    });
  }

  render() {
    const { account, payroll, web3 } = this.props;
    return (
      <div>
        <Common account={account} payroll={payroll} web3={web3} />

        <Form layout="inline" onSubmit={this.handleSubmit}>
          <FormItem>
            <InputNumber
              min={1}
              onChange={fund => this.setState({fund})}
            />
          </FormItem>
          <FormItem>
            <Button
              type="primary"
              htmlType="submit"
              disabled={!this.state.fund}
            >
              增加资金
            </Button>
          </FormItem>
        </Form>
      </div>
    );
  }
}

export default Fund