//
//  ResumeDataHelper.swift
//  Tiercel
//
//  Created by Daniels on 2019/1/7.
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

internal enum ResumeDataHelper {
    static let infoVersionKey = "NSURLSessionResumeInfoVersion"
    static let infoTempFileNameKey = "NSURLSessionResumeInfoTempFileName"
    static let infoLocalPathKey = "NSURLSessionResumeInfoLocalPath"
    static let archiveRootObjectKey = "NSKeyedArchiveRootObjectKey"

    internal static func handleResumeData(_ data: Data) -> Data? {
        data
    }

    /// 把resumeData解析成字典
    ///
    /// - Parameter data:
    /// - Returns:
    internal static func getResumeDictionary(_ data: Data) -> NSMutableDictionary? {
        // In beta versions, resumeData is NSKeyedArchive encoded instead of plist
        var object: NSDictionary?

        do {
            let keyedUnarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            object = try keyedUnarchiver.decodeTopLevelObject(of: NSDictionary.self, forKey: archiveRootObjectKey)
            if object == nil {
                object = try keyedUnarchiver.decodeTopLevelObject(of: NSDictionary.self, forKey: NSKeyedArchiveRootObjectKey)
            }
            keyedUnarchiver.finishDecoding()
        } catch {}

        if object == nil {
            do {
                object = try PropertyListSerialization.propertyList(
                    from: data,
                    options: .mutableContainersAndLeaves,
                    format: nil) as? NSDictionary
            } catch {}
        }

        if let resumeDictionary = object as? NSMutableDictionary {
            return resumeDictionary
        }

        guard let resumeDictionary = object else { return nil }
        return NSMutableDictionary(dictionary: resumeDictionary)
    }

    internal static func getTmpFileName(_ data: Data) -> String? {
        guard
            let resumeDictionary = ResumeDataHelper.getResumeDictionary(data),
            let version = resumeDictionary[infoVersionKey] as? Int
        else { return nil }
        if version > 1 {
            return resumeDictionary[infoTempFileNameKey] as? String
        } else {
            guard let path = resumeDictionary[infoLocalPathKey] as? String else { return nil }
            let url = URL(fileURLWithPath: path)
            return url.lastPathComponent
        }
    }
}
