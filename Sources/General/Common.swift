//
//  Common.swift
//  Tiercel
//
//  Created by Daniels on 2018/3/16.
//  Copyright © 2018 Daniels. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// MARK: - LogOption

public enum LogOption {
    case `default`
    case none
}

// MARK: - LogType

public enum LogType {
    case sessionManager(_ message: String, manager: SessionManager)
    case downloadTask(_ message: String, task: DownloadTask)
    case error(_ message: String, error: Error)
}

// MARK: - Logable

public protocol Logable {
    var identifier: String { get }

    var option: LogOption { get set }

    func log(_ type: LogType)
}

// MARK: - DefaultLogger

public struct DefaultLogger: Logable {
    public let identifier: String

    public var option: LogOption

    public func log(_ type: LogType) {
        guard option == .default else { return }
        var strings = [String]()
        strings.append("identifier    :  \(identifier)")
        switch type {
        case .sessionManager(let message, let manager):
            strings.append("Message       :  [SessionManager] \(message), tasks.count: \(manager.tasks.count)")
        case .downloadTask(let message, let task):
            strings.append("Message       :  [DownloadTask] \(message)")
            strings.append("Task URL      :  \(task.url.absoluteString)")
            if let error = task.error, task.status == .failed {
                strings.append("Error         :  \(error)")
            }
        case .error(let message, let error):
            strings.append("Message       :  [Error] \(message)")
            strings.append("Description   :  \(error)")
        }
        strings.append("")
        print(strings.joined(separator: "\n"))
    }
}

// MARK: - Status

public enum Status: String {
    case waiting
    case running
    case suspended
    case canceled
    case failed
    case removed
    case succeeded

    case willSuspend
    case willCancel
    case willRemove
}

// MARK: - TiercelWrapper

public struct TiercelWrapper<Base> {
    internal let base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}

// MARK: - TiercelCompatible

public protocol TiercelCompatible {}

extension TiercelCompatible {
    public static var tr: TiercelWrapper<Self>.Type { TiercelWrapper<Self>.self }

    public var tr: TiercelWrapper<Self> { TiercelWrapper(self) }

}
