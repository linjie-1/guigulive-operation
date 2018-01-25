/// <reference types="react" />
import React from 'react';
import { UploadListProps, UploadFile } from './interface';
export default class UploadList extends React.Component<UploadListProps, any> {
    static defaultProps: {
        listType: string;
        progressAttr: {
            strokeWidth: number;
            showInfo: boolean;
        };
        prefixCls: string;
        showRemoveIcon: boolean;
        showPreviewIcon: boolean;
    };
    handleClose: (file: UploadFile) => void;
    handlePreview: (file: UploadFile, e: any) => void;
    componentDidUpdate(): void;
    render(): JSX.Element;
}
