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
    private let roundedMask = CAShapeLayer()
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        let cornerRadius = bounds.height / 2.0
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        roundedMask.path = path.cgPath
        layer.mask = roundedMask
        layer.drawsAsynchronously = true
    }
}
