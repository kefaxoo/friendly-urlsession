//
//  URLRequest+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

extension URLRequest {
    public init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        self.httpMethod = method.rawValue
    }
    
    public init?(type requestType: BaseRestApiEnum, decodeToHttp: Bool = false, shouldPrintLog: Bool = false) {
        var urlComponents = URLComponents(string: requestType.baseUrl + requestType.path)
        urlComponents?.addParameters(parameters: requestType.parameters, decodeToHttp: decodeToHttp)
        
        guard let url = urlComponents?.url else { return nil }
        
        self.init(url: url, method: requestType.method)
        self.addHeaders(headers: requestType.headers)
        if let body = requestType.body {
            if let bodyType = requestType.bodyType {
                switch bodyType {
                    case .urlEncoded:
                        self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        var components = URLComponents()
                        components.queryItems = body.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
                        self.httpBody = components.query?.data(using: .utf8)
                    default:
                        guard let body = body.nsData else { break }
                        
                        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        self.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
                        self.httpBody = body as Data
                }
            } else {
                if let body = body.nsData {
                    self.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    self.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
                    self.httpBody = body as Data
                }
            }
        }
        
        if shouldPrintLog {
            Logs.shared.log(request: self)
        }
    }
    
    fileprivate mutating func addHeaders(headers: Headers?) {
        headers?.forEach({ self.addValue($0.value, forHTTPHeaderField: $0.key) })
    }
    
    public var curl: String {
        return self.makeCurl()
    }
    
    internal func makeCurl(pretty: Bool = true) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        var curl = "curl "
        var header = ""
        var data = ""
        
        if let headers = self.allHTTPHeaderFields, headers.keys.count > 0 {
            headers.forEach { key, value in
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8), !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        curl += method + url + header + data
        return curl
    }
}
