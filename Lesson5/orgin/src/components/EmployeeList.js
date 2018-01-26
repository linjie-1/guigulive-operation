import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, Popconfirm } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: '地址',
  dataIndex: 'address',
  key: 'address',
}, {
  title: '薪水',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: '上次支付',
  dataIndex: 'lastPaidDay',
  key: 'lastPaidDay',
}, {
  title: '操作',
  dataIndex: '',
  key: 'action'
}];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false,
      address: null,
      salary: null
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={text}
        onChange={ this.updateEmployee.bind(this, record.address) }
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();
      if (employeeCount === 0) {
        this.setState({loading: false});
        return;
      }
      this.loadEmployees(employeeCount);
    });
  }

  createEmployeeFromRawData = (data) => {
    const { web3 } = this.props;
    return {
      'address': data[0],
      'salary': web3.fromWei(data[1].toNumber(), 'ether'),
      'lastPaidDay': (new Date(data[2].toNumber() * 1000)).toString(),
    };
  }

  loadEmployees(employeeCount) {
    const { payroll, account } = this.props;
    const requests = [];
    for (let i = 0; i < employeeCount; i++) {
      requests.push(payroll.checkEmployee.call(
        i,
        {from: account},
      ));
    }

    Promise.all(requests).then(results => {
      const employees = results.map(value => (
        this.createEmployeeFromRawData(value)
      ));
      this.setState({
        employees: employees,
        loading: false,
      });
    });
  }

  addEmployee = () => {
    const { payroll, account } = this.props;
    payroll.addEmployee(
      this.state.address,
      this.state.salary,
      {from: account, gas: 5000000}
    ).then((result) => {
      this.setState({
        loading: false, // todo: only set loading after all employees loaded
        showModal: false,
      });
      return payroll.employees.call(
        this.state.address,
        {from: account},
      );
    }).then((result) => {
      this.setState(prevState => ({
        employees: [...prevState.employees, this.createEmployeeFromRawData(result)],
        address: null,
        salary: null,
      }));
    });
  }

  updateEmployee = (address, salary) => {
    const { payroll, account } = this.props;
    payroll.updateEmployee(
      address,
      salary,
      {from: account, gas: 5000000}
    ).then((result) => {
      this.setState({
        employees: this.state.employees.filter((x) => x.address !== address)
      });
      return payroll.employees.call(
        address,
        {from: account},
      );
    }).then((result) => {
      this.setState(prevState => ({
        employees: [...prevState.employees, this.createEmployeeFromRawData(result)],
      }));
    });
  }

  removeEmployee = (employeeId) => {
    const { payroll, account } = this.props;
    payroll.removeEmployee(
      employeeId,
      {from: account, gas: 5000000}
    ).then((result) => {
      this.setState({
        employees: this.state.employees.filter((x) => x.address !== employeeId)
      });
    });
  }

  renderModal() {
      return (
      <Modal
          title="增加员工"
          visible={this.state.showModal}
          onOk={this.addEmployee}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="地址">
            <Input
              value={this.state.address}
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              value={this.state.salary}
              onChange={salary => this.setState({salary})}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({showModal: true})}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table
          loading={loading}
          dataSource={employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
