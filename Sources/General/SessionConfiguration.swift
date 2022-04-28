//
//  SessionConfiguration.swift
//  Tiercel
//
//  Created by Daniels on 2019/1/3.
//  Copyright © 2019 Daniels. All rights reserved.
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

public struct SessionConfiguration {

    // MARK: Lifecycle

    public init() {}

    // MARK: Public

    // 请求超时时间
    public var timeoutIntervalForRequest: TimeInterval = 60.0

    public var allowsExpensiveNetworkAccess = true

    public var allowsConstrainedNetworkAccess = true

    // 是否允许蜂窝网络下载
    public var allowsCellularAccess = false

    public var maxConcurrentTasksLimit: Int {
        get { _maxConcurrentTasksLimit }
        set {
            let limit = min(newValue, Self.MaxConcurrentTasksLimit)
            _maxConcurrentTasksLimit = max(limit, 1)
        }
    }

    // MARK: Private

    private static var MaxConcurrentTasksLimit = 6

    // 最大并发数
    private var _maxConcurrentTasksLimit: Int = MaxConcurrentTasksLimit
}
