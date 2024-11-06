//
//  AffirmationCardCell.swift
//  SyncAid
//
//  Created by Sai Akshita Pokuri on 11/5/24.
//

import UIKit

class AffirmationCardCell: UICollectionViewCell {
    private let affirmationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false

        // Configure the affirmation label
        affirmationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        affirmationLabel.textColor = .darkGray
        affirmationLabel.numberOfLines = 0
        affirmationLabel.textAlignment = .center
        affirmationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(affirmationLabel)
        
        // Add constraints for the label
        NSLayoutConstraint.activate([
            affirmationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            affirmationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            affirmationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            affirmationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with affirmation: String) {
        affirmationLabel.text = affirmation
    }
}
