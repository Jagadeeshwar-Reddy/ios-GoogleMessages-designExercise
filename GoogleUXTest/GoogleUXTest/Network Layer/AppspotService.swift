//
//  AppspotService.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

final class AppspotService {
    
    static func getMessages(forPage page: PageInformation, completion: @escaping (MessagesResponse?, Error?) -> Void) {
        let route = AppspotAPI.messages(page: page)
        let request = route.request

        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            DispatchQueue.main.async {
                do {
                    if let listData = data {
                        let messages = try JSONDecoder().decode(MessagesResponse.self, from: listData)
                        completion(messages, nil)
                    } else {
                        completion(nil, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
            
            
        }.resume()
    }
}
