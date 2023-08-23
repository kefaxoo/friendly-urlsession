//
//  URLRequest+Ext.swift
//  
//
//  Created by Bahdan Piatrouski on 22.08.23.
//

import Foundation

extension URLRequest {
    fileprivate init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        self.httpMethod = method.rawValue
    }
    
    init?(type requestType: BaseRestApiEnum, decodeToHttp: Bool = false, shouldPrintLog: Bool = false) {
        var urlComponents = URLComponents(string: requestType.baseUrl + requestType.path)
        urlComponents?.addParameters(parameters: requestType.parameters, decodeToHttp: decodeToHttp)
        
        guard let url = urlComponents?.url else { return nil }
        
        self.init(url: url, method: requestType.method)
        self.addHeaders(headers: requestType.headers)
        self.httpBody = requestType.body?.data
        
        if shouldPrintLog {
            Logs.shared.log(request: self)
        }
    }
    
    fileprivate mutating func addHeaders(headers: Headers?) {
        headers?.forEach({ self.addValue($0.value, forHTTPHeaderField: $0.key) })
    }
    
    func curl(pretty: Bool = false) -> String {
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
