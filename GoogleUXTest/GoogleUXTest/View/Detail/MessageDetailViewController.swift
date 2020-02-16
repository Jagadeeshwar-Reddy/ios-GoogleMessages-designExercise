//
//  MessageDetailViewController.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var updatedOnLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var profilePictureImageView: UIImageView!

    var messageModel: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let message = messageModel {
            configure(with: message)
        }
    }
    
    func configure(with message: Message) {
        authorNameLabel.text = message.author.name
        messageLabel.text = message.content
        updatedOnLabel.text = message.redableRelativeDate
        
        if let profilePicURL = message.author.photoUrl {
            profilePictureImageView.loadImage(from: profilePicURL.absoluteString, placeHolder: UIImage.init(systemName: "person.circle"))
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
