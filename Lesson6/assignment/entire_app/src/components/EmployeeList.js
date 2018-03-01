import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: 'Address',
  dataIndex: 'address',
  key: 'address',
}, {
  title: 'Salary',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: 'Last Paid Day',
  dataIndex: 'lastPaidDay',
  key: 'lastPaidDay',
}, {
  title: 'Action',
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
      <Popconfirm title="Are you sure?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account, web3 } = this.props;
    payroll.getInfo.call({
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

  loadEmployees(employeeCount) {
    const { payroll, account, web3 } = this.props;
    const requests = [];

    for (let index = 0; index < employeeCount; index++) {
      requests.push(payroll.checkEmployee.call(index, {
        from: account
      }));
    }

    Promise.all(requests)
      .then(values => {
        const employees = values.map(value => ({
          key: value[0],
          address: value[0],
          salary: web3.fromWei(value[1].toNumber()),
          lastPaidDay: new Date(value[2].toNumber() * 1000).toString()
        }));

        this.setState({
          employees,
          loading: false
        });
      });
  }

  addEmployee = () => {
    const { employees, address, salary } = this.state;
    const { payroll, account } = this.props;
    payroll.addEmployee(address, salary, {
      from: account,
      gas: 1000000
    }).then(() => {
      const newEmployee  = {
        key: address,
        address,
        salary,
        lastPaidDay: new Date().toString()
      }

      this.setState({
        address: '',
        salary: '',
        showModal: false,
        employees: [...employees, newEmployee]
      });
    });
  }

  updateEmployee = (address, salary) => {
    const { employees } = this.state;
    const { payroll, account } = this.props;
    payroll.updateEmployee(address, salary, {
      from: account,
      gas: 1000000
    }).then(() => {
      const updatedIndex = employees.findIndex(employee => employee.address === address);
      const updatedEmployee = {
        key: address,
        address,
        salary,
        lastPaidDay: new Date().toString()
      }
      this.setState({
        employees: [...employees.slice(0, updatedIndex), updatedEmployee, ...employees.slice(updatedIndex + 1)]
      });
    });
  }

  removeEmployee = (address) => {
    const { employees } = this.state;
    const { payroll, account } = this.props;
    payroll.removeEmployee(address, {
      from: account,
      gas: 1000000
    }).then(() => {
      this.setState({
        employees: employees.filter(employee => employee.address != address)
      })
    });
  }

  renderModal() {
      return (
      <Modal
          title="Add Employee"
          visible={this.state.showModal}
          onOk={this.addEmployee}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="Address">
            <Input
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="Salary">
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
          Add Employee
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