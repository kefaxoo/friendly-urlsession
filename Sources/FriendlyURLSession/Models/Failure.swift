//
//  Failure.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

public struct Failure {
    let data: Data?
    let error: Error?
    let statusCode: Int
}
