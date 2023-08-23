//
//  URLComponents+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

internal extension URLComponents {
    mutating func addParameters(parameters: Parameters?, decodeToHttp: Bool) {
        guard let parameters else { return }
        
        self.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: (decodeToHttp ? "\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! : "\($0.value)")) })
    }
}
