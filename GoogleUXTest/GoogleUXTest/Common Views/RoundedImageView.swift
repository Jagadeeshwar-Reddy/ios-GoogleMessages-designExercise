//
//  RoundedImageView.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        layer.cornerRadius = bounds.height / 2.0
    }
}
