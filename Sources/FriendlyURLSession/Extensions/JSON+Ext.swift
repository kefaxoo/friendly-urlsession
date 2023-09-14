//
//  JSON+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

internal extension JSON {
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    var nsData: NSData? {
        return self.data as? NSData
    }
}
