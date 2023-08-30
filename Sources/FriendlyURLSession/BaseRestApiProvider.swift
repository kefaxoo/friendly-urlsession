//
//  BaseRestApiProvider.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

open class BaseRestApiProvider {
    open var shouldPrintLog: Bool {
        didSet {
            self.urlSession.shouldPrintLog = self.shouldPrintLog
        }
    }
    
    open var shouldCancelTask: Bool
    
    public let urlSession = URLSession.shared
    public var task: URLSessionTask?
    
    public init(shouldPrintLog: Bool = false, shouldCancelTask: Bool = false) {
        self.shouldPrintLog = shouldPrintLog
        self.urlSession.shouldPrintLog = shouldPrintLog
        self.shouldCancelTask = shouldCancelTask
    }
}

extension BaseRestApiProvider {
    public func checkStatusCode(_ statusCode: Int, compareTo statusCodes: [Int]) -> Bool {
        return statusCodes.contains(statusCode)
    }
    
    public func checkStatusCode(_ statusCode: Int, compareTo statusCodes: Int...) -> Bool {
        return self.checkStatusCode(statusCode, compareTo: statusCodes)
    }
}
