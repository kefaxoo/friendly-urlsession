//
//  Logs.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

class Logs {
    public static let shared = Logs()
    
    fileprivate init() {}
    
    /// Request log
    internal func log(request: URLRequest) {
        let urlString = request.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let method = request.httpMethod ?? ""
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        let host = components?.host ?? ""
        
        var requestLog = "\n----- REQUEST ----->\n"
        requestLog += "\(urlString)\n\n"
        requestLog += "\(method) \(path) \(query.isEmpty ? "" : "?\(query)") HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        requestLog += request.allHTTPHeaderFields?.getHeaders ?? ""
        requestLog += request.httpBody?.getBody ?? ""
        requestLog += "cURL: \n\(request.curl)"
        requestLog += "\n------------------->\n"
        print(requestLog)
    }
    
    /// Response log
    internal func log(data: Data?, response: URLResponse?, error: Error?) {
        let urlString = response?.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        
        var responseLog = "\n<----- RESPONSE -----\n"
        responseLog += "\(urlString)\n\n"
        var statusCodeString = ""
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            statusCodeString = "\(statusCode)"
        }
        
        responseLog += "HTTP \(statusCodeString) \(path)\(query.isEmpty ? "" : "?\(query)")\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        
        responseLog += (response as? HTTPURLResponse)?.allHeaderFields.getHeaders ?? ""
        responseLog += data?.getBody ?? ""
        responseLog += error?.getErrorLine ?? ""
        responseLog += "\n<-------------------\n"
        print(responseLog)
    }
}
