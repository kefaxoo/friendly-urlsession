//
//  Response.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

public enum Response {
    case success(response: Success)
    case failure(response: Failure)
}
