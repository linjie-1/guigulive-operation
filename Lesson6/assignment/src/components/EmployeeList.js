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
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.key)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account, web3 } = this.props;

    const update = () => {
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
    update();
    
    const updateInfo = (error, result) => {
      console.log(result)
      if (!error) {
        update()
      }
    }
    this.newEmployeeEvent = payroll.NewEmployee(updateInfo);
    this.updateEmployeeEvent = payroll.UpdateEmployee(updateInfo);
    this.removeEmployeeEvent = payroll.RemoveEmployee(updateInfo);
  }

  componentWillUnmount() {
    this.newEmployeeEvent.stopWatching();
    this.updateEmployeeEvent.stopWatching();
    this.removeEmployeeEvent.stopWatching();
  }

  loadEmployees(employeeCount) {
    const { payroll, account, web3} = this.props;
    const checkEmployeePromises = Array.from(Array(employeeCount).keys()).map(index =>{
      return payroll.checkEmployee.call(index)
    })
    Promise.all(checkEmployeePromises).then(results =>{
      const newList = results.map((result, index) =>{
        let employee = {
          address: result[0],
          salary: web3.fromWei(result[1], "ether").toNumber(),
          lastPaidDay: new Date(result[2].toNumber() * 1000).toLocaleString(),
          key: index
        }
        return employee
      })
      this.setState({
        employees: newList,
        loading: false
      })
    })
  }

  addEmployee = () => {
    const { payroll, account, web3} = this.props;
    const address = this.state.address
    const salary = this.state.salary
    payroll.addEmployee(address, salary, {from: account, gas: 1000000}).then(result => {
      alert("addEmployee success")
    })
  }

  updateEmployee = (address, salary) => {
    const { payroll, account, web3} = this.props;
    payroll.updateEmployee(address, salary, {from: account, gas: 1000000}).then(result => {
      alert("updateEmployee success")
    })
  }

  removeEmployee = (employeeIndex) => {
    const { payroll, account, web3} = this.props;
    payroll.removeEmployee(employeeIndex, {from: account, gas: 1000000}).then(result => {
      alert("removeEmployee success")
    })
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
