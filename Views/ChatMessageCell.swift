//
//  ChatMessageCell.swift
//  SyncAid
//
//  Created by Sai Akshita Pokuri on 11/4/24.
//

// ChatMessageCell.swift

import UIKit

class ChatMessageCell: UITableViewCell {
    
    private let messageLabel = UILabel()
    private let bubbleBackgroundView = UIView()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
        bubbleBackgroundView.backgroundColor = .systemGray5
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for message bubble
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: Message) {
        messageLabel.text = message.text
        
        if message.isUserMessage {
            bubbleBackgroundView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            bubbleBackgroundView.backgroundColor = .systemGray5
            messageLabel.textColor = .black
            
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
    }
}
