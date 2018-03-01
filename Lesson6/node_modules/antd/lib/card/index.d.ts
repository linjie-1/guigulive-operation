/// <reference types="react" />
import React, { Component } from 'react';
import Grid from './Grid';
export interface CardProps {
    prefixCls?: string;
    title?: React.ReactNode;
    extra?: React.ReactNode;
    bordered?: boolean;
    bodyStyle?: React.CSSProperties;
    style?: React.CSSProperties;
    loading?: boolean;
    noHovering?: boolean;
    children?: React.ReactNode;
    id?: string;
    className?: string;
}
export default class Card extends Component<CardProps, {}> {
    static Grid: typeof Grid;
    container: HTMLDivElement;
    resizeEvent: any;
    updateWiderPaddingCalled: boolean;
    state: {
        widerPadding: boolean;
    };
    componentDidMount(): void;
    componentWillUnmount(): void;
    updateWiderPadding(): void;
    saveRef: (node: HTMLDivElement) => void;
    isContainGrid(): any;
    render(): JSX.Element;
}
