//
//  BaseRestApiProvider.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

open class BaseRestApiProvider {
    private var shouldPrintLog: Bool
    
    init(shouldPrintLog: Bool = false) {
        self.shouldPrintLog = shouldPrintLog
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
