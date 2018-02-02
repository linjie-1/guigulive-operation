/// <reference types="react" />
import React from 'react';
declare class MenuItem extends React.Component<any, any> {
    static contextTypes: {
        inlineCollapsed: any;
    };
    static isMenuItem: number;
    render(): JSX.Element;
}
export default MenuItem;
