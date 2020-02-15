//
//  MessagesResponse.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

typealias Messages = [Message]

struct MessagesResponse: Decodable {
    let pageToken: String
    let count: Int
    let messages: Messages
}
