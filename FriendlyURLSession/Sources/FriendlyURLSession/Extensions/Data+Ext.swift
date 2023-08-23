//
//  Data+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

extension Data {
    var getBody: String {
        return "\(String(data: self, encoding: .utf8) ?? "ERROR: Can't render body (not utf8 encoded)")\n"
    }
}

extension Data {
    func map<T: Decodable>(from data: Data?, to type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            return nil
        }
    }
}
