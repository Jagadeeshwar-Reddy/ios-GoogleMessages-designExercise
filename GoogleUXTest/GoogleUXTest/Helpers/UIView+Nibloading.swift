//
//  UIView+Nibloading.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 20/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
    
    static func loadFromNib() -> Self? {
        func initiateFromNib<T: UIView>() -> T? {
            return nib.instantiate() as? T
        }
        
        return initiateFromNib()
    }
    
}

extension UINib {
    
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

