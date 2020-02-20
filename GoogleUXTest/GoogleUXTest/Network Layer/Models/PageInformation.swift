//
//  PageInformation.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

struct PageInformation {
    static let firstPage = PageInformation()
    
    let pageToken: String
    let itemCount: Int
    
    init(pageToken: String = "", count: Int = 25) {
        self.pageToken = pageToken
        self.itemCount = count
    }
}
