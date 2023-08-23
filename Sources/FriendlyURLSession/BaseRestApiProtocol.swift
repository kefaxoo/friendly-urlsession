//
//  File.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

public protocol BaseRestApiProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var body: JSON? { get }
}

public extension BaseRestApiProtocol {
    var body: JSON? {
        get { return nil }
    }
}
