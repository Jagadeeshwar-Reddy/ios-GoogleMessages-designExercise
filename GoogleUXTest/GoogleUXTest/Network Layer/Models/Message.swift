//
//  Message.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let identifier: Int
    let updatedDate: Date?
    let content: String
    let author: Author
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case updatedDate = "updated"
        case content
        case author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        content = try container.decode(String.self, forKey: .content)
        author = try container.decode(Author.self, forKey: .author)
        
        let dateString = try container.decode(String.self, forKey: .updatedDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let updated = formatter.date(from: dateString) {
            updatedDate = updated
        } else {
            updatedDate = nil
            assertionFailure("Could not format the updated date")
        }
    }
}
