import React, {Component} from 'react';
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';
import EditableCell from './EditableCell';


const FormItem = Form.Item;

const columns = [{
    title: '地址',
    dataIndex: 'address',
    key: 'address'
}, {
    title: '薪水',
    dataIndex: 'salary',
    key: 'salary'
}, {
    title: '上次支付',
    dataIndex: 'lastPaidDay',
    key: 'lastPaidDay'
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
        }

        columns[1].render = (text, record) => (
            <EditableCell value={text} onChange={ this.updateEmployee.bind(this, record.address) } />
        );

        columns[3].render = (text, record) => (
            <Popconfirm title="你确定删除员工吗？" onConfirm={ this.removeEmployee.bind(this, record.address) }>
                <a href="#">删除</a>
            </Popconfirm>
        );
    }

    componentDidMount() {
        const { payroll, account, web3 } = this.props;
        console.log(this.props);
        payroll.getInfo.call({
            from: account
        }).then((result) => {
            console.log(result);
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
            requests.push(payroll.checkEmployee.call(index, {from: account}));
        }

        Promise.all(requests).then(values => {
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

    // 添加员工
    addEmployee = () => {
        const { payroll, account } = this.props;
        const { address, salary, employees } = this.state;
        
        payroll.addEmployee(address, salary, {
            from: account,
            gas: 1000000
        }).then(() => {
            const newEmployee = {
                address, 
                salary, 
                key: address, 
                lastPaidDay: new Date().toString()
            }

            this.setState({
                address: '',
                salary: '',
                showModal: false,
                employees: employees.concat([newEmployee])
            });
        });
    }

    // 更新员工
    updateEmployee = (address, salary) => {
        const { payroll, account } = this.props;
        const { employees } = this.state;
        console.log(address, salary, account, employees);
        payroll.updateEmployee(address, salary, {
            from: account,
            gas: 1000000
        }).then(() => {
            this.setState({
                employees: employees.map((employee) => {
                    if (employee.address === address) {
                        employee.salary = salary;
                    }
                    return employee;
                })                
            });
        }).catch(() => {
            message.error('你没有足够的金额');
        });
    }

    // 移除员工
    removeEmployee = (address) => {
        const { payroll, account } = this.props;
        const { employees } = this.state;
        console.log(account, address, employees);
        payroll.removeEmployee(address, {
            from: account,
            gas: 1000000
        }).then((result) => {
            this.setState({
                employees: employees.filter(employee => employee.address !== address)
            });
        }).catch(() => {
            message.error('你没有足够的金额');
        }); 
    }

    renderModal() {
        return (
            <Modal 
                title="增加员工" 
                visible={this.state.showModal} 
                onOk={this.addEmployee} 
                onCancel={() => this.setState({showModal: false})}>

                <Form>
                    <FormItem label="地址">
                        <Input onChange={ev => this.setState({address: ev.target.value})} />
                    </FormItem>
                    <FormItem label="薪水">
                        <InputNumber min={1} onChange={salary => this.setState({salary})} />
                    </FormItem>
                </Form>
            </Modal>
        );
    }

    render() {
        const { loading, employees } = this.state;
        console.log(loading, employees);
        return (
            <div>
                <Button 
                    type="primary"
                    onClick={() => this.setState({showModal: true})}                
                >
                    增加员工
                </Button>
                { this.renderModal() }
                <Table 
                    loading={loading}
                    dataSource={employees}
                    columns={columns}
                />
            </div>
        );
    }
}

export default EmployeeList;