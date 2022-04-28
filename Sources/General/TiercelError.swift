//
//  TiercelError.swift
//  Tiercel
//
//  Created by Daniels on 2019/5/14.
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

// MARK: - TiercelError

public enum TiercelError: Error {
    case unknown
    case invalidURL(url: URLConvertible)
    case duplicateURL(url: URLConvertible)
    case indexOutOfRange
    case fetchDownloadTaskFailed(url: URLConvertible)
    case headersMatchFailed
    case fileNamesMatchFailed
    case unacceptableStatusCode(code: Int)
    case cacheError(reason: CacheErrorReason)

    // MARK: Public

    public enum CacheErrorReason {
        case cannotCreateDirectory(path: String, error: Error)
        case cannotRemoveItem(path: String, error: Error)
        case cannotCopyItem(atPath: String, toPath: String, error: Error)
        case cannotMoveItem(atPath: String, toPath: String, error: Error)
        case cannotRetrieveAllTasks(path: String, error: Error)
        case cannotEncodeTasks(path: String, error: Error)
        case fileDoesnotExist(path: String)
        case readDataFailed(path: String)
    }

}

// MARK: LocalizedError

extension TiercelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "unkown error"
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .duplicateURL(let url):
            return "URL is duplicate: \(url)"
        case .indexOutOfRange:
            return "index out of range"
        case .fetchDownloadTaskFailed(let url):
            return "did not find downloadTask in sessionManager: \(url)"
        case .headersMatchFailed:
            return "HeaderArray.count != urls.count"
        case .fileNamesMatchFailed:
            return "FileNames.count != urls.count"
        case .unacceptableStatusCode(let code):
            return "Response status code was unacceptable: \(code)"
        case .cacheError(let reason):
            return reason.errorDescription
        }
    }
}

// MARK: CustomNSError

extension TiercelError: CustomNSError {
    public static let errorDomain = "com.libs.Tiercel.Error"

    public var errorCode: Int {
        if case .unacceptableStatusCode = self {
            return 1001
        } else {
            return -1
        }
    }

    public var errorUserInfo: [String: Any] {
        if let errorDescription = errorDescription {
            return [NSLocalizedDescriptionKey: errorDescription]
        } else {
            return [String: Any]()
        }
    }
}

extension TiercelError.CacheErrorReason {
    public var errorDescription: String? {
        switch self {
        case .cannotCreateDirectory(let path, let error):
            return "can not create directory, path: \(path), underlying: \(error)"
        case .cannotRemoveItem(let path, let error):
            return "can not remove item, path: \(path), underlying: \(error)"
        case .cannotCopyItem(let atPath, let toPath, let error):
            return "can not copy item, atPath: \(atPath), toPath: \(toPath), underlying: \(error)"
        case .cannotMoveItem(let atPath, let toPath, let error):
            return "can not move item atPath: \(atPath), toPath: \(toPath), underlying: \(error)"
        case .cannotRetrieveAllTasks(let path, let error):
            return "can not retrieve all tasks, path: \(path), underlying: \(error)"
        case .cannotEncodeTasks(let path, let error):
            return "can not encode tasks, path: \(path), underlying: \(error)"
        case .fileDoesnotExist(let path):
            return "file does not exist, path: \(path)"
        case .readDataFailed(let path):
            return "read data failed, path: \(path)"
        }
    }
}
