//
//  Headers+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

internal extension Headers {
    var getHeaders: String {
        var headers = ""
        self.forEach { header, value in
            headers += "\(header): \(value)\n"
        }
        
        return headers
    }
}

internal extension [AnyHashable: Any] {
    var getHeaders: String {
        var headers = ""
        self.forEach { header, value in
            headers += "\(header): \(value)\n"
        }
        
        return headers
    }
}
