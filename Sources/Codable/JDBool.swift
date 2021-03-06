//
//  JDBool.swift
//  Extension
//
//  Created by ZJaDe on 2017/12/20.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//
// bool int float string
import Foundation
/** ZJaDe: 
 一个用于Codable的Bool类型
 */
public struct JDBool: BooleanLiteralTypeValueProtocol,
    Codable,
    Equatable,
    ExpressibleValueProtocol,
    ExpressibleByBooleanLiteral {

    public typealias ValueType = Bool
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        self.value = value ?? false
    }
    public init(booleanLiteral value: Bool) {
        self.value = value
    }

    public var isTrue: Bool {
        self.value == true
    }
    public var isFalse: Bool {
        self.value == false
    }

    public static func == (lhs: JDBool, rhs: Bool) -> Bool {
        lhs.isTrue == rhs
    }

    /// ZJaDe: Bool取反
    @discardableResult
    public mutating func toggle() -> JDBool {
        self.value.toggle()
        return self
    }
}
extension Optional where Wrapped == JDBool {
    public var isNilOrTrue: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isTrue
        }
    }
    public var isNilOrFalse: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isFalse
        }
    }
}
