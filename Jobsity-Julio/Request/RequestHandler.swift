//
//  Requester.swift
//  Jobsity-Julio
//
//  Created by Julio Brazil on 02/07/22.
//

import Foundation

class RequestHandler {
    static func makeRequest<T: Decodable>(_ requestDefinition: RequestDefinition, expection: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: requestDefinition.request) { data, response, error in
            // handle response to request
            // check for error
            if let error = error {
                completion(.failure((error)))
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                completion(.failure(NSError(domain: "Empty Response", code: Int(NSURLErrorBadServerResponse))))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(T.self, from: responseData)
                completion(.success(data))
            } catch (let decodingError) {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
        
    }
}
