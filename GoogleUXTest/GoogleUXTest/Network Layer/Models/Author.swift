//
//  Author.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

struct Author: Decodable {
    let name: String
    let photoUrl: URL?
    
    enum Keys: String, CodingKey {
        case name
        case photoUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        name = try container.decode(String.self, forKey: .name)
        let photoPath = try container.decode(String.self, forKey: .photoUrl)
        photoUrl = URL(string: AppspotAPI.BaseURL + photoPath)
    }
}
