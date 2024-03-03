//
//  File.swift
//  
//
//  Created by Bahdan Piatrouski on 23.08.23.
//

import Foundation

public extension URLSession {
    typealias ResponseCompletion = ((_ response: Response) -> ())
    typealias ProgressClosure = ((_ progress: Float) -> ())
    
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
    
    @discardableResult func dataTask(with request: URLRequest?, response: @escaping ResponseCompletion) -> URLSessionTask? {
        guard let request else {
            response(.failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request?.curl)))
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
                    response(.success(response: Success(data: data, statusCode: statusCode, cURL: request.curl)))
                } else {
                    if let error,
                       error.localizedDescription.lowercased() == "cancelled" {
                        response(.failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request.curl)))
                        return
                    }
                    
                    response(.failure(response: Failure(data: data, error: error, statusCode: statusCode, cURL: request.curl)))
                }
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult func dataTask(with request: URLRequest?, progressClosure: ProgressClosure? = nil, response: @escaping ResponseCompletion) -> URLSessionDataTask? {
        guard let request else {
            response(.failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request?.curl)))
            return nil
        }
        
        var progressObservation: NSKeyValueObservation?
        
        let task = self.dataTask(with: request) { [weak self] data, urlResponse, error in
            if let shouldPrintLog = self?.shouldPrintLog,
               shouldPrintLog {
                Logs.shared.log(data: data, response: urlResponse, error: error)
            }
            
            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? -1
            
            progressObservation?.invalidate()
            DispatchQueue.main.async {
                if statusCode >= 200, statusCode < 300 {
                    response(.success(response: Success(data: data, statusCode: statusCode, cURL: request.curl)))
                } else {
                    if let error,
                       error.localizedDescription.lowercased() == "cancelled" {
                        response(.failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request.curl)))
                        return
                    }
                    
                    response(.failure(response: Failure(data: data, error: error, statusCode: statusCode, cURL: request.curl)))
                }
            }
        }
        
        progressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
            progressClosure?(Float(progress.fractionCompleted))
        }
        
        task.resume()
        return task
    }
    
    @available(*, deprecated, renamed: "dataTask(with:response:)")
    func returnDataTask(with request: URLRequest?, response: @escaping((Response) -> ())) -> URLSessionTask? { return nil }
    
    @available(macOS, introduced: 12.0)
    func dataTask(with request: URLRequest?) async throws -> Response {
        guard let request else { return .failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request?.curl)) }
        
        do {
            let (data, response) = try await self.data(for: request)
            if shouldPrintLog {
                Logs.shared.log(data: data, response: response, error: nil)
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            return (statusCode >= 200 && statusCode < 300 ? .success(response: Success(data: data, statusCode: statusCode, cURL: request.curl)) : .failure(response: Failure(data: data, error: nil, statusCode: statusCode, cURL: request.curl)))
        } catch {
            if shouldPrintLog {
                Logs.shared.log(data: nil, response: nil, error: error)
            }
            
            if error.localizedDescription.lowercased() == "cancelled" {
                return .failure(response: Failure(data: nil, error: nil, statusCode: -1, cURL: request.curl))
            }
            
            return .failure(response: Failure(data: nil, error: error, statusCode: 1000, cURL: request.curl))
        }
    }
}
