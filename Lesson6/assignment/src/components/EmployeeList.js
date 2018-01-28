import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';

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
      showModal: false
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
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account,
    })
    .then((info) => {
      const totalEmployee = info[2].toNumber();
      if (totalEmployee == 0) {
        this.setState({
          loading: false,
        });
      }
      this.loadEmployees(totalEmployee);
    });
  }

  loadEmployees(totalEmployee) {
    const { web3, payroll, account } = this.props;
    const requests = [];
    for (var i = 0; i < totalEmployee; i++) {
      requests.push(payroll.checkEmployee.call(i, {
        from: account,
      }));
    }

    Promise.all(requests)
      .then((values) => {
        const employees = values.map(v => ({
          key: v[0],
          address: v[0],
          salary: web3.fromWei(v[1].toNumber()),
          lastPaidDay: new Date(v[2].toNumber() * 1000).toString(),
        }));

        this.setState({
          employees,
          loading: false,
        });
      });
  }

  addEmployee = () => {
    const { web3, payroll, account } = this.props;

    return payroll.addEmployee(
      this.state.address,
      this.state.salary,
      {
        from: account,
        gas: 1000000,
      }
    )
    .then(() => {
      alert('success');
    })
    .catch(() => {
      alert('failed');
    })
    .then(() => {
      this.setState({
        showModal: false,
      });
    });
  }

  updateEmployee = (address, salary) => {
    const { web3, payroll, account } = this.props;

    return payroll.updateEmployee(
      address,
      salary,
      {
        from: account,
        gas: 1000000,
      }
    )
    .then(() => {
      alert('success');
    })
    .catch(() => {
      alert('failed');
    });
  }

  removeEmployee = (employeeId) => {
    const { payroll, account } = this.props;

    return payroll.removeEmployee(
      employeeId,
      {
        from: account,
        gas: 1000000,
      }
    )
    .then(() => {
      alert('success');
    })
    .catch(() => {
      alert('failed');
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
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
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
