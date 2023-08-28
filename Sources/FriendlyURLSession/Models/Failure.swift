//
//  Failure.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

public struct Failure {
    public let data: Data?
    public let error: Error?
    public let statusCode: Int
}
