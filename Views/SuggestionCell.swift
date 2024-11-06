//
//  SuggestionCell.swift
//  SyncAid
//
//  Created by Sai Akshita Pokuri on 11/5/24.
//

import UIKit

class SuggestionCell: UICollectionViewCell {
    
    private let suggestionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        suggestionLabel.font = UIConstants.bodyFont
        suggestionLabel.textColor = .darkGray
        suggestionLabel.numberOfLines = 0
        suggestionLabel.textAlignment = .center
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(suggestionLabel)
        
        NSLayoutConstraint.activate([
            suggestionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            suggestionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            suggestionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            suggestionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with suggestion: String) {
        suggestionLabel.text = suggestion
    }
}
