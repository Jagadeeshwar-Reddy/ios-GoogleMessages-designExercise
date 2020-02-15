//
//  MessageTableViewCell.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    static let relativeDateFormatter: RelativeDateTimeFormatter = {
       let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var sentDateTimeLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var profilePictureImageView: UIImageView!

    private let defaultProfilePicture = UIImage.init(systemName: "person.circle")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.image = defaultProfilePicture
    }
    
    func configure(with message: Message) {
        authorNameLabel.text = message.author.name
        messageLabel.text = message.content
        
        sentDateTimeLabel.text = ""
        if let updatedOn = message.updatedDate {
            sentDateTimeLabel.text = MessageTableViewCell.relativeDateFormatter.localizedString(for: updatedOn, relativeTo: Date())
        }
        
        if let profilePicURL = message.author.photoUrl {
            profilePictureImageView.loadImage(from: profilePicURL.absoluteString,
                                              placeHolder: defaultProfilePicture)
        }
    }
}
