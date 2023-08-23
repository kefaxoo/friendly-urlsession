//
//  File.swift
//  
//
//  Created by Bahdan Piatrouski on 23.08.23.
//

import Foundation

public extension URLSession {
    fileprivate struct newVariables {
        static var shouldPrintLog: Bool = false
    }
    
    internal var shouldPrintLog: Bool {
        get {
            return newVariables.shouldPrintLog
        } set {
            newVariables.shouldPrintLog = newValue
        }
    }
    
    func dataTask(with request: URLRequest?, response: @escaping((Response) -> ())) {
        _ = self.returnDataTask(with: request, response: response)
    }
    
    func returnDataTask(with request: URLRequest?, response: @escaping((Response) -> ())) -> URLSessionTask? {
        guard let request else {
            response(.none)
            return nil
        }
        
        let task = self.dataTask(with: request) { [weak self] data, urlResponse, error in
            if let shouldPrintLog = self?.shouldPrintLog,
               shouldPrintLog {
                Logs.shared.log(data: data, response: urlResponse, error: error)
            }
            
            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? -1
            
            DispatchQueue.main.async {
                if statusCode >= 200, statusCode < 300 {
                    response(.success(response: Success(data: data, statusCode: statusCode)))
                } else {
                    if let error,
                       error.localizedDescription.lowercased() == "cancelled" {
                        response(.none)
                        return
                    }
                    
                    response(.failure(response: Failure(data: data, error: error, statusCode: statusCode)))
                }
            }
        }
        
        task.resume()
        return task
    }
}
