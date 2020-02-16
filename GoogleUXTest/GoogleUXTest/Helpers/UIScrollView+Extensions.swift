//
//  UIScrollView+Extensions.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 16/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

extension UIScrollView {
    var distanceFromBottom: CGFloat {
        return contentSize.height - (contentOffset.y + frame.size.height)
    }

    var isAtBottom: Bool {
        let contentSizeHeight = contentSize.height
        let bottomInset = adjustedContentInset.bottom
        let contentOffsetBottom = contentOffset.y + frame.size.height - bottomInset
        return (contentSizeHeight >= contentOffsetBottom) && (distanceFromBottom <= 400)
    }
}

