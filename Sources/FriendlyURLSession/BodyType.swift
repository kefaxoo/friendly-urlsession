//
//  BodyType.swift
//
//
//  Created by Bahdan Piatrouski on 15.12.23.
//

import Foundation

public enum BodyType {
    case raw
    case urlEncoded
    
    public var contentTypeHeader: String? {
        switch self {
            case .urlEncoded:
                return "application/x-www-form-urlencoded"
            default:
                return nil
        }
    }
}
