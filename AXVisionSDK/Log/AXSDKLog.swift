//
//  AXSDKLog.swift
//  AXVisionSDK
//
//  Created by lyj on 2020/07/31.
//

import Foundation

class AXSDKLog {

    class func verbose(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func info(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func warning(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func error(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func sdkCall(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func sdkInfo(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func sdkWarning(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func sdkError(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    }

    class func universalError(_ items: Any..., file: StaticString = #file, function: String = #function, line: UInt = #line) {
        fatalError("universalError occured: \(items)", file: file, line: line)
    }
}
