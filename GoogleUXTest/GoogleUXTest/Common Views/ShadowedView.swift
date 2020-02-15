//
//  ShadowedView.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowedView: UIView {
    
    @IBInspectable
    var shadowColor: UIColor {
        get{
            guard let color = layer.shadowColor else{
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set{
            layer.shadowColor = newValue.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat {
        get{
            return CGFloat(layer.shadowOpacity)
        }
        set{
            layer.shadowOpacity = Float(newValue)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get{
            return layer.shadowRadius
        }
        set{
            layer.shadowRadius = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }
}
