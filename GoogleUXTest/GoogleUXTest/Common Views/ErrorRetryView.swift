//
//  ErrorRetryView.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 20/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

class ErrorRetryView: UIView {
    typealias Action = (() -> Void)
    var retryHandler: Action?
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton! {
        didSet {
            retryButton.layer.cornerRadius = retryButton.bounds.height / 2.0
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        retryHandler?()
    }
    
    func showLoading() {
        messageLabel.isHidden = true
        retryButton.isHidden = true
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        layoutIfNeeded()
    }
    
    func showError() {
        messageLabel.isHidden = false
        retryButton.isHidden = false
        
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        layoutIfNeeded()
    }
    
}
