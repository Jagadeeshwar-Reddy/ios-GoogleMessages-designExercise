//
//  AppspotAPI.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
}

enum AppspotAPI {
    static let BaseURL = "https://message-list.appspot.com/"
    case messages(page: PageInformation)
}

extension AppspotAPI: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: AppspotAPI.BaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .messages:
            return "messages"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
        
    var headers: HTTPHeaders? {
        return ["contentType": "application/json"]
    }
    
    // TODO: Comeup with a better way of constructing the requesting and encoding the parameters
    var request: URLRequest {
        switch self {
        case .messages(let page):
            var request = URLRequest(url: baseURL.appendingPathComponent(path))
            request.httpMethod = httpMethod.rawValue
            
            if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = []
                
                let pageTokenQueryItem = URLQueryItem(name: "pageToken", value: page.pageToken.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(pageTokenQueryItem)

                let countQueryItem = URLQueryItem(name: "limit", value: "\(page.itemCount)")
                urlComponents.queryItems?.append(countQueryItem)
                
                request.url = urlComponents.url
            }
            return request
        }
    }
}

enum HTTPMethod: String {
    case get    =   "GET"
    case post   =   "POST"
}

typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]
