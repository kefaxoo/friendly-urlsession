//
//  Error+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

internal extension Error {
    var getErrorLine: String {
        return "ERROR: \(self.localizedDescription)"
    }
}
