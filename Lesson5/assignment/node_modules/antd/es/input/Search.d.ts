/// <reference types="react" />
import React from 'react';
import { InputProps } from './Input';
export interface SearchProps extends InputProps {
    inputPrefixCls?: string;
    onSearch?: (value: string) => any;
}
export default class Search extends React.Component<SearchProps, any> {
    static defaultProps: {
        inputPrefixCls: string;
        prefixCls: string;
    };
    input: any;
    onSearch: () => void;
    render(): JSX.Element;
}
