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

    columns[1].render = (text, record) => {
      return <EditableCell
        value={text}
        onChange={ this.updateEmployee.bind(this, record.address) }
      />
    };

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll } = this.props;
    const updateInfo = (error, result) => {
      if (error) {
        return;
      }
      this.loadAllEmployees();
    }

    this.getPaidEvent = payroll.GetPaid(updateInfo);
    this.newEmployeeEvent = payroll.NewEmployee(updateInfo);
    this.updateEmployeeEvent = payroll.UpdateEmployee(updateInfo);
    this.removeEmployeeEvent = payroll.RemoveEmployee(updateInfo);

    this.loadAllEmployees();
  }

  componentWillUnmount() {
    this.getPaidEvent.stopWatching();
    this.newEmployeeEvent.stopWatching();
    this.updateEmployeeEvent.stopWatching();
    this.removeEmployeeEvent.stopWatching();
  }

  loadAllEmployees = () => {
    const { payroll, account } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();
      if (employeeCount === 0) {
        this.setState({
          loading: false,
          employees: []
        });
      } else {
        this.loadEmployeesHelper(employeeCount);
      }
    }).catch((error) => {
      console.log(error);
      alert("加载员工失败！！！");
    });
  }

  loadEmployeesHelper = (employeeCount) => {
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
    }).catch((error) => {
      console.log(error);
      alert("加载员工失败！！！");
    });
  }

  createEmployeeFromRawData = (data) => {
    const { web3 } = this.props;
    return {
      'address': data[0],
      'salary': web3.fromWei(data[1].toNumber()),
      'lastPaidDay': (new Date(data[2].toNumber() * 1000)).toString(),
    };
  }

  addEmployee = () => {
    const { payroll, account } = this.props;
    payroll.addEmployee(
      this.state.address,
      this.state.salary,
      {from: account, gas: 5000000}
    ).then((result) => {
      if (parseInt(result.receipt.status, 10) === 1) {
        this.setState({
          loading: false,
          showModal: false,
          salary: null,
          address: null,
        });
        alert("增加员工成功！");
      } else {
        console.log(result);
        alert("增加员工失败！！！");
      }
    }).catch((error) => {
      console.log(error);
      alert("增加员工失败！！！");
    });
  }

  updateEmployee = (address, salary) => {
    const { payroll, account } = this.props;
    payroll.updateEmployee(
      address,
      salary,
      {from: account, gas: 5000000}
    ).then((result) => {
      if (parseInt(result.receipt.status, 10) === 1) {
        alert("更新员工薪水成功！");
      } else {
        console.log(result);
        alert("更新员工薪水失败！！！");
      }
    }).catch((error) => {
      console.log(error);
      alert("更新员工薪水失败！！！");
    });
  }

  removeEmployee = (employeeId) => {
    const { payroll, account } = this.props;
    payroll.removeEmployee(
      employeeId,
      {from: account, gas: 5000000}
    ).then((result) => {
      if (parseInt(result.receipt.status, 10) === 1) {
        alert("删除员工成功！");
      } else {
        console.log(result);
        alert("删除员工失败！！！");
      }
    }).catch((error) => {
      console.log(error);
      alert("删除员工失败！！！");
    });
  }

  handleSalaryChange = (value) => {
    this.setState({salary: value});
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
              value={this.state.salary}
              min={1}
              onChange={this.handleSalaryChange}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
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
          loading={this.state.loading}
          dataSource={this.state.employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
