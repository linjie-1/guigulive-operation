import React from 'react';

export default function Accounts({
    accounts = [],
    onSelectAccount
}) {
    return (
        <div className = "pure-menu sidebar">
            <span className = "pure-menu-heading">账户列表</span>

            <ul className = "pure-menu-list">
                { accounts.map(account => (
                  <li className = "pure-menu-item" key={account} onClick={onSelectAccount}>
                    <a href="#" className="pure-menu-link">{account}</a>
                  </li>))

                }
            </ul>
        </div>
    );
}