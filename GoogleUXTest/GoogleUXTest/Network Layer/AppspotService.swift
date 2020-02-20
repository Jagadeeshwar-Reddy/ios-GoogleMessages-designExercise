//
//  AppspotService.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

final class AppspotService {
    
    static func getMessages(forPage page: PageInformation, completion: @escaping (MessagesResponse?, APIDataTaskError?) -> Void) {
        let route = AppspotAPI.messages(page: page)
        let request = route.request

        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            if let listData = data {
                do {
                    let messages = try JSONDecoder().decode(MessagesResponse.self, from: listData)
                    completion(messages, nil)
                } catch {
                    completion(nil, APIDataTaskError.parsingError)
                }
            } else if let error = error {
                completion(nil, APIDataTaskError.apiError(message: error.localizedDescription))
            } else {
                completion(nil, APIDataTaskError.other)
            }
            
        }.resume()
    }
}

enum APIDataTaskError: Error {
    case parsingError
    case apiError(message: String)
    case other
    
    var localizedDescription: String {
        switch self {
        case .parsingError:
            return "Could not parse the data"
        case .apiError(let message):
            return message
        case .other:
            return "Something went wrong"
        }
    }
    
}
