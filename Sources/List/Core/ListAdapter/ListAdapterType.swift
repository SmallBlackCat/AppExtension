//
//  ListAdapterType.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol DataSourceSectiontype: Diffable {}
public protocol DataSourceItemtype: Diffable, Equatable {}
public protocol AdapterItemType: DataSourceItemtype & CanSelectedStateDesignable {}
public protocol AdapterSectionType: DataSourceSectiontype & InitProtocol & HiddenStateDesignable {}

public protocol ListAdapterType {
    associatedtype DataSource: SectionedDataSourceType
    var rxDataSource: DataSource { get }
}
extension ListAdapterType {
    public var dataController: DataSource.DataControllerType {
        return rxDataSource.dataController
    }
}
