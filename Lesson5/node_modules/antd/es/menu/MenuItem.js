import _classCallCheck from 'babel-runtime/helpers/classCallCheck';
import _createClass from 'babel-runtime/helpers/createClass';
import _possibleConstructorReturn from 'babel-runtime/helpers/possibleConstructorReturn';
import _inherits from 'babel-runtime/helpers/inherits';
import React from 'react';
import { Item } from 'rc-menu';
import PropTypes from 'prop-types';
import Tooltip from '../tooltip';

var MenuItem = function (_React$Component) {
    _inherits(MenuItem, _React$Component);

    function MenuItem() {
        _classCallCheck(this, MenuItem);

        return _possibleConstructorReturn(this, (MenuItem.__proto__ || Object.getPrototypeOf(MenuItem)).apply(this, arguments));
    }

    _createClass(MenuItem, [{
        key: 'render',
        value: function render() {
            var inlineCollapsed = this.context.inlineCollapsed;

            var props = this.props;
            return React.createElement(
                Tooltip,
                { title: inlineCollapsed && props.level === 1 ? props.children : '', placement: 'right', overlayClassName: props.rootPrefixCls + '-inline-collapsed-tooltip' },
                React.createElement(Item, props)
            );
        }
    }]);

    return MenuItem;
}(React.Component);

MenuItem.contextTypes = {
    inlineCollapsed: PropTypes.bool
};
MenuItem.isMenuItem = 1;
export default MenuItem;