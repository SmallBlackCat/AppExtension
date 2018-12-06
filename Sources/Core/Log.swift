//
//  Log.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 16/9/23.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation

private let dateFormat = "'当前时间: 'HH: mm: ss.SSS"
public protocol LogUploadProtocol {
    func logUpload(_ level: LogLevel, _ message: String)
}
public enum LogLevel: String {
    case debug = "Debug"
    case info = "Info"
    case warn = "Warn"
    case error = "Error"
}
public struct Logger {
    private init() {}
    static var shared: Logger = Logger()
    private let tag: String = jd.appDisplayName ?? "未知App名称"
    private let timeFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = dateFormat
        return result
    }()
    fileprivate func log(_ level: LogLevel, _ message: String) {
        if Thread.isMainThread {
            privateLog(level, message)
        } else {
            DispatchQueue.main.async {
                self.privateLog(level, message)
            }
        }
    }
    private func privateLog(_ level: LogLevel, _ message: String) {
        var str: String = ""
        switch level {
        case .debug: str.append("🚑 ")
        case .info: str.append("ℹ️ ")
        case .warn: str.append("⚠️ ")
        case .error: str.append("❌ ")
        }
        str.append("\(tag)(\(level.rawValue)) ")
        str.append("🕒\(timeFormatter.string(from: Date())): ")
        str.append(message)
        print(str)
    }
}
public func logTimer(_ closure: () -> Void) {
    #if DEBUG || Beta || POD_CONFIGURATION_BETA
    logDebug("开始计时")
    let date = Date().timeIntervalSince1970
    closure()
    logDebug("结束计时\(date - Date().timeIntervalSince1970)")
    #endif
}
// MARK: - 在 Relase 模式下，关闭后台打印
public func logDebug<T>(_ message: @autoclosure () -> T) {
    #if DEBUG || Beta || POD_CONFIGURATION_BETA
        Logger.shared.log(.debug, "\(message())")
    #endif
}
public func logInfo<T>(_ message: @autoclosure () -> T) {
    if let logger = Logger.shared as? LogUploadProtocol {
        logger.logUpload(.info, "\(message())")
    }
    #if DEBUG || Beta || POD_CONFIGURATION_BETA
        Logger.shared.log(.info, "\(message())")
    #endif
}
public func logWarn<T>(_ message: @autoclosure () -> T, file: StaticString = #file, method: String = #function, line: UInt = #line) {
    if let logger = Logger.shared as? LogUploadProtocol {
        logger.logUpload(.warn, "\(file)[\(line)], \(method): \(message())")
    }
    #if DEBUG || Beta || POD_CONFIGURATION_BETA
    Logger.shared.log(.warn, "\(file)[\(line)], \(method): \(message())")
    #endif
}
public func logError<T>(_ message: @autoclosure () -> T, file: StaticString = #file, method: String = #function, line: UInt = #line) {
    if let logger = Logger.shared as? LogUploadProtocol {
        logger.logUpload(.error, "\(file)[\(line)], \(method): \(message())")
    }
    #if DEBUG || Beta || POD_CONFIGURATION_BETA
        Logger.shared.log(.error, "\(file)[\(line)], \(method): \(message())")
    #endif
}
